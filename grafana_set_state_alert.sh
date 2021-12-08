#!/bin/bash
# ./grafana_set_state_alert.sh [ID_DASHBOARD] [pause/play]

# sudo apt install jq

date

ID_DASHBOARD="$1"
URL_GRAFANA="grafana.url.com"
CLE_API="grafana_api_key"

function usage(){
    echo "usage : set_state_alert.sh [ID_DASHBOARD] [pause/play]"
} 

function get_id_alert(){    
    curl -k --location --request GET "https://${URL_GRAFANA}/api/alerts?dashboardId=${ID_DASHBOARD}" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}" | jq -r '.[] | [.id] | @csv '
}

# set_pause_alert [ID_ALERT]
function set_pause_alert(){
    ID_ALERT=$1
    curl -ksH --location --request POST "https://${URL_GRAFANA}/api/alerts/${ID_ALERT}/pause" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}" --data '{ "paused": true }'
}

# set_play_alert [ID_ALERT]
function set_play_alert(){
    ID_ALERT=$1
    curl -k --location --request POST "https://${URL_GRAFANA}/api/alerts/${ID_ALERT}/pause" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}" --data '{ "paused": false }'
}

case $2 in
    pause) get_id_alert | while read -r line; do set_pause_alert "$line"; done 2>&1; printf "\n";;
     play) get_id_alert | while read -r line; do set_play_alert "$line"; done 2>&1; printf "\n"  ;;
        *) usage ;;
esac