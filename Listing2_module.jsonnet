// module.jsonnet

local source = import "source.jsonnet";

local select_generator(object) =
    local fields = [f.name for f in object.fields];
    local table = object.table;

    if std.length(fields) == 0 then
        error "The object must have at least one field."
    else
        "select "
        + std.join(", ", fields)
        + " from " + table;

local hour_parser(hour_str) = 
    if hour_str == "*" then 
        std.range(0, 23)
    else if std.length(hour_str) < 3 then
        [std.parseInt(hour_str)]
    else 
        local parts = std.split(hour_str, "/");
        local base = if parts[0] == "*" then 0 else std.parseInt(parts[0]);
        local step = std.parseInt(parts[1]);
        [num + base for num in std.range(0, 23 - base) if num % step == 0];

local not_null_generator(object, field) = 
    "select case when count(*) = count(" + field + ") "
    + "then 'true' else 'false' end as test_passed from " 
    + object.table;
{
    "name": source.table,
    "constraints": [
        not_null_generator(source, c)
        for c in source.constraints.field_is_not_null
    ],
    "import_sql": select_generator(source),
    "run_import_hours": hour_parser(source.run_import),
    "run_checks_hours": hour_parser(source.run_checks)
}

