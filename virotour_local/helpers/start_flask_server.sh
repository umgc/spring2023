# This script is meant to be run inside virotour_local folder.
(
    cd ./flask
    pyenv activate virotour-3.9.16
    pip install -r requirements.txt
    python run.py
)