#!/bin/sh
# file: setup_c.sh
# author: Osmar Daniel G. Arevalo
# Crea un entorno para correr codigo C++
# sin necesidad de crear un archivo fuente


if [[ ! $(gcc -dumpversion) > 4.9.1 ]]
	then
	echo "Se necesita una version de GCC 4.9.2 o mas reciente..."
	exit 1
fi

HEADERS=cppenviron_headers.hpp

create_headers()
{
	cat > $HEADERS <<---

	// Librerias necesaria para
	// correr cppenviron
	// autor: Osmar Daniel G. Arevalo.

	#ifndef CPPENVIRON_HEADERS_HPP
	#		define CPPENVIRON_HEADERS_HPP 1L
	#			include <iostream>
  #			include <string>
  #			include <sstream>
	#			include <locale>
	#			include <iomanip>
	#			include <fstream>
	#			include <regex>
	#			include <cmath>
	#			include <ctime>
	#			include <chrono>
	#			include <vector>
	#			include <algorithm>
	#			include <iterator>
	#			include <list>
	#			include <map>
	#			include <set>
	#			include <queue>
	#			include <deque>
	#			include <cstdlib>
	#			include <typeinfo>
	#			include <typeindex>
	#			include <type_traits>
	#			include <functional>
	#			include <utility>
	#			include <memory>
	#			include <limits>
	#			include <unistd.h>
	#			include <random>
	#			include <ratio>
	#			include <numeric>
	#			include <valarray>
	#			include <complex>
	#			include <unordered_map>
	#			include <unordered_set>
	#			include <stack>
	#			include <forward_list>
	#			include <thread>
	#			include <mutex>
	#			include <future>
	#			include <stdexcept>
	#			include <system_error>
	#endif

	using namespace std;

	// alternativa a std::to_string
	template<class Type>
	string as_string(const Type& t)
	{
		ostringstream out;
		out << t;
		return out.str();
	}

	// conveniente para usar string + Number -> string
	template<class Number>
	string operator+(const string& ss, const Number& num)
	{
		return ss + as_string(num);
	}

	--
}
## Nombre del entorno
CXX_ENV_=cppenviron

[ ! -f $HEADERS ] && create_headers

LDLIBS=-lstdc++
CXXFLAGS='-std=c++14 -Wall -pedantic -Wextra -O2 -g -pthread'
CXX=gcc
PROG=program.exe ## nombre del ejecutable en Windows

echo "======================================================="
echo "Creando $CXX_ENV_ ..."
echo "======================================================="

cat > $CXX_ENV_ <<---
  alias run_cpp='${CXX} -xc++ "-" -o ${PROG} -include ${HEADERS} ${CXXFLAGS} ${LDLIBS}'
	--

cat <<---
		Ahora corra el comando:

		\$ source ${CXX_ENV_}

		esto creará la utilidad 'run_cpp' que corre una cadena de texto
		con codigo C++. Ejemplo:

		\$ echo 'int main() { std::cout << "Hola Geek++\n"; }' > runcpp

		o si son varias lineas de codigo:

		\$ runcpp <<-end
		int main(){
			auto num = 42;
			cout << "El cuadrado de "s + num + " es "s + num*num + "\n";
		}
		end
		--
exit 0
