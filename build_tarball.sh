#!/bin/sh

# The CCTOOLS we are to use
#cctoolsVer="current"
cctoolsVer="4.1.4rc5"

# Override the default it given
[[ ! -z $1 ]] && cctoolsVer=$1

# Were we can find the cctools tarball
cctoolsHome=/home/www/download


# The pCVMFS we are to use
pcvmfsVer="2.1.19"

# Override the default it given
[[ ! -z $1 ]] && pcvmfsVer=$2

# Where we can find the pCVMFS tarball
pcvmfsHome=/home/www/download



# Additions to support CVMFS via Connect

function f_maketarball () {

  # Factory for which we are building this tarball
  factoryName=$1

  # CCTOOLS to use
  cctoolsVer=$2

  # Get a working temp directory
  tmpHome=$(mktemp -d)

  # Location where to build
  connectHome="${tmpHome}/connect"

  # Create all the directories we need
  mkdir -p ${connectHome}

  # Untar the requested cctools version into the home area
  tar --extract --gzip --directory=${tmpHome} --file=${cctoolsHome}/cctools-${cctoolsVer}.tar.gz

  # Add a copy of the CVMFS public keys
  cp    ${buildHome}/cern.ch.pub                ${connectHome}/cern.ch.pub
  cp    ${buildHome}/cern-it1.cern.ch.pub       ${connectHome}/cern-it1.cern.ch.pub
  cp    ${buildHome}/cern-it2.cern.ch.pub       ${connectHome}/cern-it2.cern.ch.pub
  cp    ${buildHome}/cern-it3.cern.ch.pub       ${connectHome}/cern-it3.cern.ch.pub
  cp    ${buildHome}/osg.mwt2.org.pub           ${connectHome}/osg.mwt2.org.pub

  # Parrot needs some support executables and libraries which might not exist at the target
  cp -r ${buildHome}/bin                        ${connectHome}/bin
  cp -r ${buildHome}/lib                        ${connectHome}/lib
  cp -r ${buildHome}/lib64                      ${connectHome}/lib64
  cp -r ${buildHome}/python                     ${connectHome}/python

  # Copy the CCTools products we need
  cp    ${tmpHome}/cctools/bin/parrot_run       ${connectHome}/bin
  cp -r ${tmpHome}/cctools/lib/lib              ${connectHome}
  cp -r ${tmpHome}/cctools/lib/lib64            ${connectHome}

  # Untar the PortableCVMFS into the Connect Home area
  tar --extract --gzip --directory=${connectHome} --file=${pcvmfsHome}/PortableCVMFS-${pcvmfsVer}.tar.gz

  # Copy over the $OSG_APP area
  cp -r ${buildHome}/OSG_APP                    ${connectHome}/OSG_APP

  # Add a copy of the job wrappers
  cp ${buildHome}/functions.sh                  ${connectHome}/functions.sh;       chmod 755 ${connectHome}/functions.sh
  cp ${buildHome}/connect_wrapper.sh            ${connectHome}/connect_wrapper.sh; chmod 755 ${connectHome}/connect_wrapper.sh
  cp ${buildHome}/setup_ace.sh                  ${connectHome}/setup_ace.sh;       chmod 755 ${connectHome}/setup_ace.sh
  cp ${buildHome}/setup_osg.sh                  ${connectHome}/setup_osg.sh;       chmod 755 ${connectHome}/setup_osg.sh
  cp ${buildHome}/setup_ca.sh                   ${connectHome}/setup_ca.sh;        chmod 755 ${connectHome}/setup_ca.sh
  cp ${buildHome}/site.conf.$factoryName        ${connectHome}/site.conf;          chmod 755 ${connectHome}/site.conf
  cp ${buildHome}/exec.sh                       ${connectHome}/exec.sh;            chmod 755 ${connectHome}/exec.sh



  # Create the tarball
  tar --create --gzip --file=${tmpHome}/connect.tar.gz --directory=${tmpHome} connect


  # Put a copy in a place others can wget
  cp ${tmpHome}/connect.tar.gz                  /home/www/download/connect.tar.gz.${factoryName}

  # Destroy the working temp directory
  rm -rf ${tmpHome}

  echo "Built tarball with CCTOOLS ${cctoolsVer} for factory ${factoryName}"

}


# Where all our needed files should live
buildHome="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Make all the tarballs

f_maketarball generic        ${cctoolsVer}
f_maketarball icc            ${cctoolsVer}
f_maketarball icc_golub      ${cctoolsVer}
f_maketarball icc_hept3      ${cctoolsVer}
f_maketarball icc_mcore      ${cctoolsVer}
f_maketarball icc_taub       ${cctoolsVer}
f_maketarball midway         ${cctoolsVer}
f_maketarball midway_mcore   ${cctoolsVer}
f_maketarball mwt2           ${cctoolsVer}
f_maketarball mwt2_mcore     ${cctoolsVer}
f_maketarball odyssey        ${cctoolsVer}
f_maketarball odyssey_short  ${cctoolsVer}
f_maketarball stampede       ${cctoolsVer}
f_maketarball stampede_mcore ${cctoolsVer} 
f_maketarball uci            ${cctoolsVer}
f_maketarball utexas         ${cctoolsVer}
