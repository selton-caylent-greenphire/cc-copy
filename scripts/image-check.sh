#!/bin/bash

get_images() {
	kubectl get deployments,statefulsets,daemonsets,cronjobs -n $NAMESPACE -o jsonpath="{..image}"| tr -s '[[:space:]]' '\n' | sort | uniq -c
}

if [ -z "$EMAIL_TO" -o \
	 -z "$FROM_EMAIL" -o \
	 -z "$FROM_NAME" -o \
	 -z "$SUBJECT" -o \
	 -z "$SENDGRID_API_KEY" -o \
	 -z "$NAMESPACE" ]
then
	echo "Must set environment variables: EMAIL_TO, FROM_EMAIL, FROM_NAME, SUBJECT, NAMESPACE"
	exit 1
fi

while :
do
	Images="$(get_images)"
	if [ -z "$OldImages" ]; then
		OldImages=$Images
		continue;
	fi
	
	if [ "$OldImages" = "$Images" ]; then
		echo "Completed image check. All images match."
	else
		echo "Completed image check. There is a mismatch."
		diff=$(diff <(echo "$OldImages") <(echo "$Images") | sed 's/</\&lt;/g;s/>/\&gt;/g;s/$/<br>/' | tr '\n' ' ')

		bodyHTML="<head></head><body><h3>Image Monitor Has Detected a Change, Diff:</h3><tt>$diff</tt></body>"

		maildata='{"personalizations":[{"to":[{"email":"'${EMAIL_TO}'"}],"subject":"'${SUBJECT}'"}],"content": [{"type": "text/html", "value": "'${bodyHTML}'"}],"from":{"email":"'${FROM_EMAIL}'","name":"'${FROM_NAME}'"}}'

		curl --request POST \
		  --url https://api.sendgrid.com/v3/mail/send \
		  --header 'Authorization: Bearer '$SENDGRID_API_KEY \
		  --header 'Content-Type: application/json' \
		  --data "$maildata"
	fi
	
	sleep 30
	OldImages=$Images

done
