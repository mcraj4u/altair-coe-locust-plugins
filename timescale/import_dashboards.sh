#!/bin/bash
ds=(10878 14423 14422);
for d in "${ds[@]}"; do
  echo -n "Processing $d: "
  j=$(curl -s -k -u "$GRAFANA_CRED" $GRAFANA_HOST/api/gnet/dashboards/$d | jq .json)
  curl -s -k -u "$GRAFANA_CRED" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"dashboard\":$j,\"overwrite\":true, \
        \"inputs\":[
            {\"name\":\"VAR_SEND_INTERVAL\",\"type\":\"constant\",\"value\": \"5\"},\
            {\"name\":\"DS_LOCUST\",\"type\":\"datasource\", \"pluginId\":\"postgres\",\"value\":\"$DS_NAME\"}\
        ]}"\
    $GRAFANA_HOST/api/dashboards/import; echo ""
done