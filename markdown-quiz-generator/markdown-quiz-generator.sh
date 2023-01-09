#!/bin/bash

# https://github.com/osandadeshan/markdown-quiz-generator

# https://github.com/osandadeshan/markdown-quiz-generator#installation

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Running markdown-quiz-generator"
echo -e '\e[38;5;198m'"++++ "

cd /vagrant/markdown-quiz-generator

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Installing Pip dependencies"
echo -e '\e[38;5;198m'"++++ "
python -m pip install -r requirements.txt

# https://github.com/osandadeshan/markdown-quiz-generator#generating-quizzes
# generate quizzes
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ python quiz-generator.py"
echo -e '\e[38;5;198m'"++++ "
rm -rf /vagrant/markdown-quiz-generator/generated-quizzes/*
python quiz-generator.py

cd generated-quizzes

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Check if Quiz server is running"
echo -e '\e[38;5;198m'"++++ "
sudo touch /var/log/markdown-quiz-generator.log
sudo chmod 777 /var/log/markdown-quiz-generator.log
if pgrep -x "python" >/dev/null
then
  echo "++++ Quiz is running, killing"
  sudo kill -9 $(ps aux | grep 8000 | grep -v grep | tr -s " " | cut -d " "  -f2)
fi

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Start Quiz server - python -m http.server 8000"
echo -e '\e[38;5;198m'"++++ "
sudo python -m http.server 8000 > /var/log/markdown-quiz-generator.log 2>&1 &
