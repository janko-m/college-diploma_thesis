# Diploma thesis

My Diploma thesis, on topic of full-text search.

## Generating LaTeX

On Mac you can generate and open the PDF by running

```sh
$ brew install rubber
$ rubber --pdf --inplace diplomski.tex
$ open diplomski.pdf
```

## Setup engines

```sh
$ bundle install
$ bundle exec rake setup
```

Naturally, you need to make sure that all of your engines are running.

## Run tests

```sh
$ bundle exec cucumber
```
