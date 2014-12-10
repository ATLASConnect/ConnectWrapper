#!/bin/bash


# Where all our needed files should live
buildHome="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the Connect Wrapper version
source ${buildHome}/setup_defaults.sh

# Download Home area
downloadHome=/home/www/download


# The CCTOOLS we are to use
#cctoolsVer="current"
cctoolsVer="4.2.2"
#cctoolsVer="4.1.4rc5"

# Override the default it given
[[ ! -z $1 ]] && cctoolsVer=$1

# Were we can find the cctools tarball
cctoolsHome=${downloadHome}

# The pCVMFS we are to use
pcvmfsVer="2.1.19"

# Override the default it given
[[ ! -z $1 ]] && pcvmfsVer=$2

# Where we can find the pCVMFS tarball
pcvmfsHome=${downloadHome}



# Additions to support CVMFS via Connect

function f_maketarball () {

  # CCTOOLS to use
  cctoolsVer=$1

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
  cp ${buildHome}/connect_wrapper.sh            ${connectHome}/connect_wrapper.sh; chmod 755 ${connectHome}/connect_wrapper.sh
  cp ${buildHome}/setup_defaults.sh             ${connectHome}/setup_defaults.sh;  chmod 755 ${connectHome}/setup_defaults.sh
  cp ${buildHome}/setup_functions.sh            ${connectHome}/setup_functions.sh; chmod 755 ${connectHome}/setup_functions.sh
  cp ${buildHome}/setup_ace.sh                  ${connectHome}/setup_ace.sh;       chmod 755 ${connectHome}/setup_ace.sh
  cp ${buildHome}/setup_osg.sh                  ${connectHome}/setup_osg.sh;       chmod 755 ${connectHome}/setup_osg.sh
  cp ${buildHome}/setup_ca.sh                   ${connectHome}/setup_ca.sh;        chmod 755 ${connectHome}/setup_ca.sh
  cp ${buildHome}/setup_site.sh                 ${connectHome}/setup_site.sh;      chmod 755 ${connectHome}/setup_site.sh
  cp ${buildHome}/exec.sh                       ${connectHome}/exec.sh;            chmod 755 ${connectHome}/exec.sh



  # Create the tarball
  tar --create --gzip --file=${tmpHome}/connect.tar.gz --directory=${tmpHome} connect


  # Put a copy in a place others can wget
  cp ${tmpHome}/connect.tar.gz                  ${downloadHome}/connect.tar.gz.${connectWrapperVersion}

  # Destroy the working temp directory
  rm -rf ${tmpHome}

  echo "Built ConnectWrapper ${connectWrapperVersion} tarball with CCTOOLS ${cctoolsVer}"

  # Make it the active wrapper
  rm -f ${downloadHome}/connect.tar.gz
  cp ${downloadHome}/connect.tar.gz.${connectWrapperVersion} ${downloadHome}/connect.tar.gz

  echo "ConnectWrapper ${connectWrapperVersion} is marked current"

}



# Make all the tarballs

f_maketarball ${cctoolsVer}
