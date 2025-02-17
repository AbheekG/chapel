.. _readme-prereqs:

====================
Chapel Prerequisites
====================

If you have a standard UNIX environment, a C/C++ compiler, some basic
scripting languages, a GNU-compatible make, and awk installed you should
have no problems getting started with Chapel.


Prerequisites
-------------

In slightly more detail, the following are prerequisites and assumptions
about your environment for using Chapel:

  * You are using an environment that supports standard UNIX commands
    such as: ``cd, mkdir, rm, echo``

  * You have the Bourne shell available at ``/bin/sh``, the C-shell
    available at ``/bin/csh``, 'env' available at ``/usr/bin/env``, and
    that 'env' can locate Perl and Python on your system.

  * You have access to gmake or a GNU-compatible version of make.

  * You have access to standard C and C++ compilers. We test our code
    using a range of compilers on a nightly basis; these include
    relatively recent versions of gcc/g++, clang, and compilers from
    Cray, Intel, and PGI.

  * If you wish to use Chapel's test system, python-devel or an
    equivalent package for your platform is required.


Installation
------------

We have used the following commands to install the above prerequisites

  * CentOS::

      sudo yum install gcc gcc-c++ perl python python-devel bash make gawk

  * SLES::

      sudo zypper install gcc gcc-c++ perl python python-devel bash make gawk

  * Debian, Ubuntu::

      sudo apt-get install gcc g++ perl python python-dev bash make mawk
