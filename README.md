# MIPS Calculator

mipsCalc is a simple recursive descent intepreter written in mips assembly. It is capeable of interpreting simple arithematic expressions involving addition, subtraction, multiplication, division, and exponentiation. It also supports grouping by parenthesis and the definition of single letter variables. This code was written using and can be run by the [MARS - MIPS Assembler and Runtime Simulator](http://courses.missouristate.edu/KenVollmar/mars/).

## Running the code

To assemble and run mipsCalc, download [MARS](http://courses.missouristate.edu/KenVollmar/mars/). To be able to run MARS anywhere you can do something like this:

```bash
mkdir ~/.bin
mv path/to/mars/jar/download ~/.bin/mars.jar
chmod +x ~/.bin/mars.jar
echo "alias mars='java -jar ~/.bin/mars.jar'" >> ~/.bashrc
source ~/.bashrc
```
Then, after cloning the repo you can run the interpreter like

```bash
mars main.asm
```

