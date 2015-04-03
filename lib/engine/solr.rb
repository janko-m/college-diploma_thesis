require "rsolr"
require "faraday"
require "pathname"
require "fileutils"
require "active_support/core_ext/hash/keys"

class Engine
  class Solr < Engine
    def setup
    end

    def clear
      client.delete_by_query "*:*"
      client.commit
    end

    def import(movies)
      client.add movies.map.with_index { |movie, idx| movie.merge(id: idx) }
      client.commit
    end

    def search(query, page: nil, per_page: nil, highlight: nil, **options)
      options.each do |key, action|
        _, operator, value = action.rpartition(/^[<>=]*/)
        operator = "=" if operator.empty?
        query <<
          case operator
          when "="  then " #{key}:(#{value})"
          when ">=" then " #{key}:[#{value} TO *}"
          when ">"  then " #{key}:{#{value} TO *}"
          when "<=" then " #{key}:{*        TO #{value}]"
          when "<"  then " #{key}:{*        TO #{value}}"
          end
      end
      params = {q: query, defType: "edismax"}
      params.merge!("hl": true, "hl.fl": "*", "hl.simple.pre": "<strong>", "hl.simple.post": "</strong>", "hl.fragsize": 0) if highlight
      response =
        if per_page
          client.paginate page, per_page, "select", params: params
        else
          client.get "select", params: params
        end

      unless response.has_key?("highlighting")
        response["response"]["docs"].map(&:symbolize_keys)
      else
        response["highlighting"].values.map do |hash|
          hash.symbolize_keys!
          hash.each { |key, value| hash[key] = value.first }
          hash
        end
      end
    end

    private

    def client
      @client ||= RSolr.connect
    end
  end
end

__END__

schema.xml
=============

<?xml version="1.0" encoding="UTF-8" ?>
<schema name="movies" version="1.5">
  <field name="_version_" type="long"   indexed="true" stored="true" />
  <field name="id"        type="string" indexed="true" stored="true" required="true" multiValued="false" />
  <uniqueKey>id</uniqueKey>

  <field name="title"     type="text"   indexed="true" stored="true" />
  <field name="year"      type="int"    indexed="true" stored="true" />
  <field name="plot"      type="text"   indexed="true" stored="true" />
  <field name="episode"   type="text"   indexed="true" stored="true" />

  <field name="text" type="text" indexed="true" stored="false" multiValued="true" />
  <copyField source="title"   dest="text"/>
  <copyField source="year"    dest="text"/>
  <copyField source="plot"    dest="text"/>
  <copyField source="episode" dest="text"/>

  <fieldType name="string" class="solr.StrField" />
  <fieldType name="int"    class="solr.TrieIntField" />
  <fieldType name="long"   class="solr.TrieLongField" />
  <fieldType name="text"   class="solr.TextField">
    <analyzer>
      <charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII.txt"/>
      <tokenizer class="solr.StandardTokenizerFactory" />
      <filter class="solr.SynonymFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="false" />
      <filter class="solr.StopFilterFactory" words="stopwords.txt" ignoreCase="true" />
      <filter class="solr.LowerCaseFilterFactory" />
      <filter class="solr.EnglishPossessiveFilterFactory" />
      <filter class="solr.PorterStemFilterFactory" />
    </analyzer>
  </fieldType>

 <defaultSearchField>text</defaultSearchField>
 <solrQueryParser defaultOperator="AND"/>
</schema>

schemaconfig.xml
================

...


  <requestHandler name="/select" class="solr.SearchHandler">
    <lst name="defaults">
      <str name="echoParams">explicit</str>
      <str name="qf">title^4 year^4 plot^2 episode^2</str>
      <str name="df">text</str>
    </lst>
    ...
  </requestHandler>

...
