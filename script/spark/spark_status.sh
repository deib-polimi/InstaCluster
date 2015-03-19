
usage="Usage: spark_status.sh <spark-command> <spark-instance-number>"

# if no args specified, show usage
if [ $# -le 1 ]; then
  echo $usage
  exit 1
fi


sbin="$SPARK_HOME/sbin"

. "$sbin/spark-config.sh"

command=$1
shift
instance=$1
shift



. "$SPARK_PREFIX/bin/load-spark-env.sh"


if [ "$SPARK_IDENT_STRING" = "" ]; then
  export SPARK_IDENT_STRING="$USER"
fi

pid="$SPARK_PID_DIR/spark-$SPARK_IDENT_STRING-$command-$instance.pid"

if [ -f $pid ]; then
    cat $pid
else
    echo "no"
fi
