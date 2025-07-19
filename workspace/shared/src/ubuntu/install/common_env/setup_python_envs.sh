#!/usr/bin/env bash
set -ex

# Common Python Virtual Environments Setup - Shared across all environments
echo "=== [3/5] Creating Python virtual environments ==="
mkdir -p /opt/venvs && chmod 755 /opt/venvs

# Flask Environment
if [ ! -d /opt/venvs/flaskenv ]; then
    echo "=== ✅ Creating flaskenv... ==="
    python3 -m venv /opt/venvs/flaskenv
    source /opt/venvs/flaskenv/bin/activate
    pip install --upgrade pip
    pip install \
        Flask \
        requests \
        SQLAlchemy \
        Werkzeug \
        Flask-Login \
        Flask-SQLAlchemy \
        Flask-Migrate \
        Flask-RESTful \
        Flask-Cors \
        PyJWT \
        pandas \
        numpy \
        matplotlib \
        seaborn \
        scikit-learn \
        pymysql \
        psycopg2-binary \
        python-dotenv \
        boto3
    deactivate
    echo "=== ✅ flaskenv ready ==="
else
    echo "=== ✅ flaskenv already exists ==="
fi

# Pages Environment
if [ ! -d /opt/venvs/pagesenv ]; then
    echo "=== ✅ Creating pagesenv... ==="
    python3 -m venv /opt/venvs/pagesenv
    source /opt/venvs/pagesenv/bin/activate
    pip install --upgrade pip
    pip install \
        nbconvert \
        nbformat \
        pyyaml \
        notebook \
        requests \
        python-dotenv \
        pandas \
        seaborn \
        scikit-learn \
        progress \
        newspaper3k \
        wikipedia \
        emoji \
        lxml_html_clean
    deactivate
    chmod -R a+rX /opt/venvs
    echo "=== ✅ pagesenv ready ==="
else
    echo "=== ✅ pagesenv already exists ==="
fi

echo "=== ✅ Python Virtual Environments Setup Complete ==="
