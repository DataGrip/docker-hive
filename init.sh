#!/bin/bash

if [ ! -z $HIVE_TEST_DB ]; then	
    echo "HIVE_TEST_DB: $HIVE_TEST_DB"
else
	HIVE_TEST_DB=test
    echo "HIVE_TEST_DB: $HIVE_TEST_DB"
fi

export STATUS=0
i=0
while [[ $STATUS -eq 0 ]] || [[ $i -lt 90 ]]; do
	sleep 1
	i=$((i+1))
	STATUS=$(netstat -anp | grep 10000 | wc -l)
done

/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 <<-EOSQL
CREATE DATABASE $HIVE_TEST_DB;
EOSQL

echo ""
cat << EOF
+--------------------------------------------------+
|               CREATE DATABASE $HIVE_TEST_DB;              |
+--------------------------------------------------+
EOF

# /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 <<-EOSQL
# set hive.strict.checks.cartesian.product = false;
# EOSQL

# echo ""
# cat << EOF
# +--------------------------------------------------+
# |                       set                        |
# +--------------------------------------------------+
# | set hive.strict.checks.cartesian.product = false;|
# +--------------------------------------------------+
# EOF

#trap
while [ "$END" == '' ]; do
			sleep 1
			trap "END=1" INT TERM
done

