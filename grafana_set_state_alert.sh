#!/bin/bash
# ./grafana_set_state_alert.sh [ID_DASHBOARD] [pause/play]

ID_DASHBOARD="$1"
URL_GRAFANA="grafana.url.com"
CLE_API="grafana_api_key"

function usage(){
    echo "usage : set_state_alert.sh [ID_DASHBOARD] [pause/play]"
} 

# get_id_alert 
function get_id_alert(){
    CURL_ID_ALERT=$(curl -k --location --silent --request GET "https://${URL_GRAFANA}/api/alerts?dashboardId=${ID_DASHBOARD}" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}")
    ID_ALERT=$( echo ${CURL_ID_ALERT} | for i in * ; do awk -F ':' '{print $2}';done | for i in * ; do awk -F ',' '{print $1}';done )   
}

function set_pause_alert(){
    curl -k --location --request POST "https://${URL_GRAFANA}/api/alerts/${ID_ALERT}/pause" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}" --data '{ "paused": true }'
}

function set_play_alert(){
    curl -k --location --request POST "https://${URL_GRAFANA}/api/alerts/${ID_ALERT}/pause" --header 'Accept: application/json' --header 'Content-Type: application/json' --header "Authorization: Bearer ${CLE_API}" --data '{ "paused": false }'
}

case $2 in
    pause) get_id_alert && set_pause_alert ;;
     play) get_id_alert && set_play_alert  ;;
        *) usage ;;
esac