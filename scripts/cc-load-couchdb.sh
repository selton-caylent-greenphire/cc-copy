#!/bin/bash
RESTORE="/clincard-config/scripts/couchdb-dump.sh"

if [ -z $COUCH_PASSWORD ]; then
    echo "CouchDB Password not set. Please make sure COUCH_PASSWORD is set."
    exit 1
fi

if [ -z $COUCH_SVC ]; then
    echo "CouchDB service is not set. Please make sure COUCH_SVC is set."
    exit 1
fi

if [ -z $S3_BUCKET ]; then
    echo "S3 bucket containing CouchDB dumps is not defined. Please make sure that $COUCH_SVC is set."
    exit 1
fi

if [ -z $INIT_DBS ]; then
    echo "Database(s) to initialize is not defined. Please make sure that $INIT_DBS is set."
    exit 1
fi

for db in $(echo $INIT_DBS|tr -d '[:space:]'|tr ',' '\n')
do
    aws s3api head-object --bucket $S3_BUCKET --key $db.json.gz.enc > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        aws s3 cp s3://$S3_BUCKET/$db.json.gz.enc /root
        openssl aes-256-cbc -d -a -salt -pass pass:$COUCH_PASSWORD -in /root/$db.json.gz.enc -out /root/$db.json.gz > /dev/null 2>&1
        gunzip /root/$db.json.gz
        curl -s http://$COUCH_SVC:5984/$db|grep -q "not_found"
        if [ $? -eq 0 ]; then
            # Database not present
            $RESTORE -r -H $COUCH_SVC -d $db -f /root/$db.json -u admin -p $COUCH_PASSWORD -c
        else
            # Database is present
            DOCS_IN_DB=$(curl -s http://$COUCH_SVC:5984/$db|jq -r '.doc_count'|tr -d '\n')
            DOCS_IN_FILE=$(cat /root/$db.json | jq -r ".docs" | jq length | tr -d '\n')
            if [ $DOCS_IN_DB -lt $DOCS_IN_FILE ]; then
                $RESTORE -r -H $COUCH_SVC -d $db -f /root/$db.json -u admin -p $COUCH_PASSWORD
            else
                echo "Database already seeded, not initializing."
            fi
        fi
    else
        echo "No init dump for $db present in $S3_BUCKET, skipping ... "
    fi
done
