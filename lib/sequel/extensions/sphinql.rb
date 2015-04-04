module SphinQL
  Sequel::Dataset.def_sql_method(self, :select, %w[
    select distinct calc_found_rows columns from join where group having
    compounds order limit option lock
  ])

  def option(sql)
    clone(:option => sql)
  end

  def select_option_sql(sql)
    if option = opts[:option]
      sql << " OPTION " << option
    end
  end

  Sequel::Dataset.register_extension(:sphinql, self)
end
