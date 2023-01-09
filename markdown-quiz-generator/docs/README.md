# Markdown Quiz Generator

### Introduction
It is a tool to generate quizzes from Markdown files. This means that you can structure the format of the text, bold, italic, tables, etc.

<b> Markdown: </b> <br>
![p1](images/sample-quiz-md-file.PNG)

<b> Quiz generated: </b> <br>
![p2](images/sample-quiz-animation.gif)

### Requirements
[Python-3.7.x](https://www.python.org/downloads/release/python-374/) <br>
Be sure to install **pip** when installing python.

### Installation
Once `python` and `pip` are installed, simply run `install.bat`, this batch file will simply install the required packages.

If you want to do it manually, simply run (within the application already downloaded): <br>
`python -m pip install -r requirements.txt`

### Quiz structure (Markdown)
Although it is based on markdown for its style format, at the moment the following types of questions are supported:

1. **Question of a selection**:
```text
1. MaxSoft is a software company.
    - (x) True
    - ( ) False
```
```text
2. The domain of MaxSoft is test automation framework development.
    - (x) True
    - ( ) False 
```
Note that the correct answer is specified with an **x** ( x or X, upper or lower case) and must be in parentheses to specify that it is only one to be selected, for example, for false or true questions.

2. **Multiple selection question**:
```text
3. What are the test automation frameworks developed by MaxSoft?
    - [x] IntelliAPI
    - [x] WebBot
    - [ ] Gauge
    - [ ] Selenium
```
Very similar to the previous one but this type of question allows you to select more than one at a time, they must be in square brackets with an **x** to the correct answers. The result to these types of questions is prorated, that is, you must select only the correct ones so that that question is interpreted as correct.

Note that for questions types 1 and 2, you must leave a space for the wrong answers, eg. () or [], the questions must be multiple selection or a selection, you cannot mix them.

3. **Open question** (Enter text)
```text
4. Who is the Co-Founder of MaxSoft?
    - R:= Osanda
```
It is a question where you must write the correct answer, this is specified in the following line of the question preceded by **R: =** (R or, upper or lower case) then the correct answer (it is validated regardless of whether it is uppercase or lowercase)

### Designing the quiz
There are several tools out there on the internet that allow you to preview Markdown files. 
Some online examples:

1. https://dillinger.io/
2. https://markdownlivepreview.com/

### Generating quizzes
The application will generate all the **.md** (Markdown) files that are inside the folder 
`./markdown-quiz-files/**`. Note that this folder already has a default quiz (sample-quiz.md).

You can add as many as Markdown files you want, and each of them will be generated separate quizzes.

To generate quizzes, there are two batch files,
1. `quiz-generator-local.bat` \
This is a batch file that simply executes `python quiz-generator.py` and will generate the quizzes including the required libraries (Bootstrap, jQuery) to execute it independently in the browser (usually to verify that everything is fine).

2. `quiz-generator-local-server.bat` \
This is a batch file that executes, 
```
python quiz-generator.py
cd generated-quizzes
start http://localhost:8000/
python -m http.server 8000
```
This is almost same as `quiz-generator-local.bat`. The only difference is, this will spin up a new local server for your quizzes at http://localhost:8000/

3. `quiz-generator-embed.bat` \
This is a batch file that simply executes `python quiz-generator.py embed` in this way the quizzes will be generated without including any external library, it is assumed that it will be included in another Web as (Embedded).

The resulting quizzes will have the same name of the markdown file but with their .html extension, they will be created in the `./generated-quizzes/` folder.