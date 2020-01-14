#!/bin/bash

pylint -f parseable webserver | tee pylint.out
py.test --cov-report html --cov-report xml \
    --junitxml=junit.xml \
    --cov=webserver \
    --cov-report term-missing ${@}
