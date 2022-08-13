#! /bin/bash

function rm_Dockerfile() {
  #statements
  local parent=$(pwd)
  local target=$1

  #change to bin dir
  cd $target

  #go up one level
  cd ../

  #remove Dockerfile if exists in prj_dir
  if [[ -e ./Dockerfile ]]; then
    #statements
    rm -f ./Dockerfile

    #copy Dockerfile from .src
    cp $parent/.src/Dockerfile .

  fi

  #switch baxk to project dir
  cd $parent
}

function create_bazel_wrkspace() {
  #statements

  local prj_dir=$1
  local tmp_dir=$2
  local build="build.sc"

case $prj_dir in
  *h2* ) build="build-h2.sc" ;;
  *hsqldb* ) build="build-hsqldb.sc" ;;
  *derby* ) build="build-derby.sc" ;;
esac

  rm -f $tmp_dir/build.gradle

  #copy WORKSPACE file from src folder
  cp .src/$build $tmp_dir/build.sc

  rm_Dockerfile $tmp_dir

  mkdir $tmp_dir/CLI

  mv $tmp_dir/src $tmp_dir/CLI
}

function log_path() {
  #statements
  local file=$1
  local old="\/app"
  local new="\/tmp"

  sed -i "s/${old}/${new}/" $file
}

d=$1

for e in `find $d -type d -name bin`; do

log_path $e/src/main/java/example/Main.java

if [[ -e $e/src/main/java/example/dto/Dog.java ]]; then
  #statements
  log_path $e/src/main/java/example/dto/Dog.java
else
  log_path $e/src/main/java/example/dto/Generic.java
fi
  #statements
  create_bazel_wrkspace $d $e
done
