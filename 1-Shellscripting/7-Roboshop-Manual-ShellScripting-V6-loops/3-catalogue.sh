source common.sh
component_name=catalogue
echo Log file output: ${logfile} # this comes from common.sh
schema_load=true
schema_type=mysql

schema_files="schema.sql app-user.sql master-data.sql"

golang_app