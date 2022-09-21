{
    {{- if .gunicornBlock }}
    "gunicorn": {
        "bind": {{ default "0.0.0.0:8080" .gunicornBind | quote}},
        "workers": {{ default 3 .gunicornWorkers}},
        "threads": {{ default 1 .gunicornThreads}},
        "timeout": {{ default 30 .gunicornTimeout}},
        "access_log_format": "remote!%({X-Forwarded-For}i)s|method!%(m)s|url-path!%(U)s|query!%(q)s|username!%(u)s|protocol!%(H)s|status!%(s)s|response-length!%(b)s|referrer!%(f)s|user-agent!%(a)s|request-time!%(L)s",
        "accesslog": {{ default "-" .gunicornAccesslog | quote}} ,
        "logger_class": {{ default "jslog4kube.GunicornLogger" .gunicornLoggerClass | quote}}
    },
    {{- end }}
    "logging": {
        "version": {{ default 1 .loggingVersion}},
        "disable_existing_loggers": {{ default false .loggingDisableExistingLoggers}},
        "formatters": {
            "simple": {
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            }
        },
        "handlers": {
            "logstash": {
                "class": {{ default "logstash.TCPLogstashHandler" .handlerLogstashClass | quote}},
                "host": {{ default "logstash-service.logging.svc.cluster.local" .handlerLogstashHost | quote}},
                "port": {{ default 5959 .handlerLogstashPort }},
                "version": {{ default 1 .handlerLogstashVersion }},
                "tags": [ {{ default "service" .loggerServiceName | quote}} ]
            },
            "console": {
                "class": {{ default "logging.StreamHandler" .handlerConsoleClass | quote}},
                "level": {{ default "INFO" .handlerConsoleLevel | quote}},
                "formatter": {{ default "simple" .handlerConsoleFormatter | quote}},
                "stream": {{ default "ext://sys.stdout" .handlerConsoleStream | quote}}
            },
            "info_file_handler": {
                "class": {{ default "logging.handlers.RotatingFileHandler" .handlerInfoFileClass | quote}},
                "level": {{ default "INFO" .handlerInfoFileLevel | quote}},
                "formatter": {{ default "simple" .handlerInfoFileFormatter | quote}},
                "filename": {{ default "info.log" .handlerInfoFileName | quote}},
                "maxBytes": {{ default 10485760 .handlerInfoFileMaxBytes}},
                "backupCount": {{ default 20 .handlerInfoFileBackupCount}},
                "encoding": {{ default "utf8" .handlerInfoFileEncoding | quote}}
            },
            "error_file_handler": {
                "class": {{ default "logging.handlers.RotatingFileHandler" .handlerErrorFileClass | quote}},
                "level": {{ default "ERROR" .handlerErrorFileLevel | quote}},
                "formatter": {{ default "simple" .handlerErrorFileFormatter | quote}},
                "filename": {{ default "errors.log" .handlerErrorFileName | quote}},
                "maxBytes": {{ default 10485760 .handlerErrorFileMaxBytes}},
                "backupCount": {{ default 20 .handlerErrorFileBackupCount}},
                "encoding": {{ default "utf8" .handlerErrorFileEncoding | quote}}
            }
        },
        "loggers": {
            {{ default "service" .loggerServiceName | quote}}: {
                "level": {{ default "DEBUG" .loggerServiceLevel | quote}},
                "handlers": ["logstash"],
                "propagate": {{ default false .loggerServicePropagate }}
            }
        },
        "root": {
            "level": {{ default "DEBUG" .loggerRootLevel | quote}},
            "handlers": ["logstash"]
        }
    }
}