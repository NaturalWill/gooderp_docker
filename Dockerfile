FROM ubuntu:14.04
MAINTAINER gooderp61001
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#Install and setup postgresql
RUN set -x; \
        apt-get update \
        && apt-get install -y postgresql
USER postgres
RUN /etc/init.d/postgresql start  && psql --command "CREATE USER root WITH SUPERUSER CREATEDB REPLICATION;"
RUN /etc/init.d/postgresql start  && psql --command "alter user root with password 'root';"
USER root
ENV PGDATA /var/lib/postgresql/data
 # Install some deps, lessc and less-plugin-clean-css
# Cannot install wkhtmltopdf,default in ubuntu without header&footer
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends --assume-yes \
            sudo \
            ca-certificates curl node-less npm python-gevent python-pyinotify \
            python-renderpm git-core git-gui git-doc \
 python-dateutil  python-docutils python-feedparser  python-gdata python-jinja2 python-ldap python-libxslt1 python-lxml \
 python-mako python-mock python-openid python-psycopg2 python-psutil python-pybabel python-pychart python-pydot \
 python-pyparsing python-reportlab  python-simplejson \
 python-tz python-unittest2 python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml \
 python-zsi python-pyPdf python-decorator python-passlib python-requests\
        python-dev python-pip python-setuptools \
        libffi-dev libxml2-dev libxslt1-dev postgresql-client postgresql-contrib\
        libtiff4-dev libjpeg8-dev zlib1g-dev libfreetype6-dev python-imaging\
        liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python-tk python-psycopg2
       
# Usage: WORKDIR /pathdocker 
WORKDIR ~/
#Install Odoo
MAINTAINER CLONE 相应的项目
RUN set -x; \
        pip install decorator docutils ebaysdk feedparser gevent greenlet jcconv \ 
Jinja2 lxml Mako MarkupSafe mock ofxparse passlib psutil psycogreen  pydot pyparsing pyPdf \
pyserial Python-Chart python-dateutil python-ldap python-openid pytz pyusb PyYAML qrcode requests \
six suds-jurko vatnumber vobject Werkzeug wsgiref XlsxWriter xlwt xlrd xlutils docxtpl python-ooxml&&\
         git clone https://github.com/osbzr/base.git&&\
         git clone https://github.com/osbzr/gooderp_addons.git


COPY ./oe.conf  /~/base/
# Copy Odoo configuration file
# odoo.conf will be modified after set DATABASE MANAGE PASSWORD
ENV HOST_BASE_DIR /~/base
ENV INSTANCE_NAME base
VOLUME ["${HOST_BASE_DIR}/addons:/addons",
        "${HOST_BASE_DIR}/customers/${INSTANCE_NAME}/var/lib/postgresql:/var/lib/postgresql",
        "${HOST_BASE_DIR}/customers/${INSTANCE_NAME}/extra-addons:/extra-addons",
        "${HOST_BASE_DIR}/customers/${INSTANCE_NAME}/data:/data"]

# Set the default config file
#RUN mkdir /extra-addons && mkdir /data
 

EXPOSE 8069

# Copy startup script
COPY ./startup.sh /
ENTRYPOINT ["/bin/bash","/startup.sh"]

