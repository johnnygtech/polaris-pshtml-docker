FROM mcr.microsoft.com/powershell:6.1.0-ubuntu-18.04

#environmentl
ENV PORT 8080

#create non-root user
RUN useradd -u 10001 psuser

#copy the website and set working directory
COPY  /website /app
COPY /Polaris /app/Polaris
COPY /PSHTML /app/PSHTML
WORKDIR /app

#expose the website
EXPOSE $PORT

#switch user
USER psuser
#start website
ENTRYPOINT ["pwsh", "./Start-Website.ps1" ]
#monitor
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "pwsh", "-command", "if($(Invoke-WebRequest $('http://localhost:{0}' -f $Env:PORT)).statusCode -ne 200) {exit 1}" ]

# Metadata parameters
ARG VERSION
ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE

# Metadata ("http://label-schema.org/rc1/")
LABEL org.label-schema.vendor="Stijn Callebaut" \
      org.label-schema.name="PowerShell Polaris PShtml linux container for ExpertsLive EU 2018" \
      org.label-schema.description="PowerShell Polaris webserver running in a Linux container. Webpages are built using PowerShell PSHTML" \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-url="https://github.com/stijnc/polaris-pshtml-docker" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.schema-version="1.0" \
      readme.md="https://github.com/stijnc/polaris-pshtml-docker/README.md"