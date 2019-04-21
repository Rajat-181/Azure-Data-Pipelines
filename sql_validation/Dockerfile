FROM python:3
#COPY chg_validate.py /
#COPY requirements.txt /
#RUN pip install -r requirements.txt

COPY Insert-Into-SQL.py /
COPY test.csv /

RUN cat /etc/os-release

# Update to install apt-transport package
RUN apt-get update
RUN apt-get install -y apt-transport-https

# Add Microsoft APT Key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Download appropriate package based on Debian Version
RUN export DEBIAN_VERSION=`cat /etc/os-release | grep "VERSION_ID" | cut -d'=' -f2 | cut -d'"' -f2` && echo $DEBIAN_VERSION && curl  "https://packages.microsoft.com/config/debian/${DEBIAN_VERSION}/prod.list" > /etc/apt/sources.list.d/mssql-release.list

# Update to include packages for installation
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Optional for sql command line tools (sqlcmd and bcp)
RUN ACCEPT_EULA=Y apt-get install mssql-tools

# Optional for unixODBC Development Headers
RUN apt-get install unixodbc-dev

# install SQL Server Python SQL Server connector module - pyodbc
RUN pip install pyodbc

CMD [ "python", "Insert-Into-SQL.py" ]
