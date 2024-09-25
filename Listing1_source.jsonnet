// source.jsonnet

{
    "database": "db",
    "schema": "dbo",
    "table": "employee",
    "fields": [
        {
            "name": "id",
            "type": "int",
        },
        {
            "name": "first_name",
            "type": "nvarchar(100)"
        }
    ],
    "constraints": {
        "field_is_not_null": [
            "id"
        ]
    },
    "run_import": "*/4",
    "run_checks": "0"
}



