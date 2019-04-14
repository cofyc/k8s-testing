#!/bin/bash

sudo -E env "PATH=$PATH" go test -benchtime 10s -bench .
