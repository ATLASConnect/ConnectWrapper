#!/bin/bash

######################################################################################


# The version of the wrapper
export connectWrapperVersion="3.0-4"


######################################################################################
# Native CVMFS, nfsCVMFS, PortableCVMFS, Parrot/CVMFS or Parrot/Chirp Wrapper
######################################################################################
# 
#
# The following variables will modify the action taken by the Connect Wrapper
# 
# These should be set in the site.conf script based on the requirements of the site
#
# At the minimum, $cvmfsType should be defined to one of the following values
#
# 	native		Use System installed CVMFS,    HEPOS_libs and Certificate Authority
#	parrot		Use Parrot to access CVMFS,    ACE Cache available
#	nfs		Use System installed nfsCVMFS, ACE Cache available
#	portable	Use PortableCVMFS,             ACE Cache available
#
# Default value for $cvmfsType is "native"
#
#
# The ACE Cache contains and ACE Image (for HEPOS_lib), OSG WN Client and a Certicate Authority
# The ACE Cache componitents can be local (default tarball installation) or a CVMFS repository
# The ACE Image can be bypassed and the System libraries used
#
# If Parrot/CVMFS is used, Parrot can "mount" access into the ACE Image
#
#
######################################################################################
#
# If connectUseNativeONLY is defined, use Native access for all components
#
# These include
#
#	CVMFS Client	"Native" installation of "/cvmfs" and all CERN repositories (MWT2 might not be available)
#	HEP_OSlibs	Installed on the system along with all other needed compatibility libraries
#	$OSG_APP	Defined by the system or within site.conf
#	$OSG_GRID	Defined by the system or within site.conf
#	$OSG_WN_TMP	Setup by this wrapper within the job sandbox
#	$X509_CERT_DIR	Defined by the system or within site.conf or a CA at /etc/grid-security/certificates
#
#export connectUseNativeONLY=True


# If connectUsePortableCVMFS is defined, use PortableCVMFS to access all /cvmfs repositories
# By default, it is assume that /cvmfs is mounted locally
# The wrapper will setup access to an ACE Image (via env var), OSG WN Client and Certficate Authority
#export connectUsePortableCVMFS=True


# If connectUseParrotCVMFS is defined, use Parrot to access all /cvmfs repositories
# By default, it is assume that /cvmfs is mounted locally
# The wrapper will setup access to an ACE Image (via Parrot mounts), OSG WN Client and Certficate Authority
#export connectUseParrotCVMFS=True


# If connectUseParrotChirp is defined, we will use a Chirp Server to access /cvmfs
# By default, Parrot/CVMFS will be used to access all CVMFS repositories
# This setting only has meaning if connectUseParrotCVMFS is also defined
#export connectUseParrotChirp=True


# If connectUseParrotMount is defined (and using Parrot for CVMFS access), use Parrot --mount to access ACE Image
# By default, ACE Image access will be via environment variables (same as other CVMFS access types)
#export connectUseParrotMount=True


# If connectUseCVMFSaceImageTB is defined, we will use an ACE Image from a Tarball installed in the ACE Cache
# By default, an ACE Image from a CVMFS repository will be used
#export connectUseCVMFSaceImageTB=True


# If connectUseCVMFSaceWNCtb is defined, we will use the OSG WN Client from a Tarball installed in the ACE Cache
# By default, the OSG WNC Client from a CVMFS repository will be used
#export connectUseCVMFSaceWNCtb=True


# If connectUseCVMFSaceCAtb is defined, we will use a Certificate Authority from an installation in the ACE Cache
# By default, a Certificate Authority from a CVMFS repoisitory will be used
#export connectUseCVMFSaceCAtb=True


# If connectUseSystemLIB is defined, we will use an local System libraries for HEPOS_libs, etc
# By default, LD_LIBRARY_PATH, etc will be modified to use the ACE Image libraries
#export connectUseSystemLIB=True


# If connectUseParrotThreadCloneFix is defined, we will use the Parrot Thread Clone Bugfix
# By default, the Bugfix will not be used
# Use of this feature will most likley have sever impact on performance
# Only 4.1.4rc5 currently supports this feature
#export connectUseParrotThreadCloneFix=True


# The Chirp Server upon which the CVMFS repositories are statically mounted and accessible
#export connectParrotChirpServer="uct2-c320.mwt2.org"
#export connectParrotChirpServer="uct2-int.mwt2.org"


# The blocksize to use for Parrot/Chirp, 1M or 2M
#export connectParrotChirpBlocksize=1048576
#export connectParrotChirpBlocksize=2097152


# If connectUsePrivateParrotCache is defined, we setup a Per Job Private Cache
# By default, the Parrot Cache is shared by all jobs on the same node
#export connectUsePrivateParrotCache=True


# Location of the ACE Image if connectUseCVMFSaceImageTB is not defined
#export connectCVMFSaceImage=/cvmfs/osg.mwt2.org/atlas/sw/ACE/current
#export connectCVMFSaceImage=/cvmfs/cernvm-prod.cern.ch/cvm3


# Location of the OSG WN Client if connectUseCVMFSaceWNCtb is not defined
#export connectCVMFSaceWNC=/cvmfs/osg.mwt2.org/osg/sw


# Location of the Certificate Authority repository if connectUseCVMFSaceCAtb is not defined
#export connectCVMFSaceCA=/cvmfs/osg.mwt2.org/osg/CA


######################################################################################
# Basic Connect defintions we need to start
######################################################################################

# Signal list for traps
export connectTRAP="EXIT HUP INT TERM QUIT ABRT ILL BUS FPE"

# Save the command line to be executed
export connectCMD="$@"

# Where we are located
export connectHome="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


######################################################################################
# Function definitions
######################################################################################

source ${connectHome}/functions.sh


#########################################################################################
# Site definitions
#########################################################################################

# Setup the local site definitions
source ${connectHome}/site.conf


#########################################################################################
# Based on CVMFS Access Type, etc, make certain definitions make sense
#########################################################################################

# If we have not defined a CVMFS access type, use undefined
[[ -z "${cvmfsType}" ]] && export cvmfsType="undefined"


# Set value values based on the CVMFS Access Type

case ${cvmfsType} in

  # Use Parrot to access /cvmfs

  (parrot)

    export connectUseNativeONLY=''
    export connectUseParrotCVMFS=True
    export connectUseNfsCVMFS=''
    export connectUsePortableCVMFS=''

  ;;


  # Use nfsCVMFS to access /cvmfs

  (nfs)

    export connectUseNativeONLY=''
    export connectUseParrotCVMFS=''
    export connectUseNfsCVMFS=True
    export connectUsePortableCVMFS=''

  ;;


  # Use PorableCVMFS to access /cvmfs

  (portable)

    export connectUseNativeONLY=''
    export connectUseParrotCVMFS=''
    export connectUseNfsCVMFS=''
    export connectUsePortableCVMFS=True

  ;;


  # By default, CVMFS access will be Native

  (*)

    export connectUseNativeONLY=True
    export connectUseParrotCVMFS=''
    export connectUsePortableCVMFS=''
    export connectUseNfsCVMFS=''
    export connectUseSystemLIB=True

  ;;


esac


# If we are using type System libraries (not the ACE Image), undefine UseParrotMount
[[ -n "${connectUseSystemLIB}" ]] && export connectUseParrotMount=''


# The Chirp Server upon which the CVMFS repositories are statically mounted and accessible
[[ -z "${connectParrotChirpServer}" ]] && export connectParrotChirpServer="uct2-int.mwt2.org"
#[[ -z "${connectParrotChirpServer}" ]] && export connectParrotChirpServer="uct2-c320.mwt2.org"

# The blocksize to use for Parrot/Chirp, 1M or 2M
[[ -z "${connectParrotChirpBlocksize}" ]] && export connectParrotChirpBlocksize=2097152
#[[ -z "${connectParrotChirpBlocksize}" ]] && export connectParrotChirpBlocksize=1048576



# Location of the ACE Image if connectUseCVMFSaceImageTB is not defined
[[ -z "${connectCVMFSaceImage}" ]] && export connectCVMFSaceImage=/cvmfs/osg.mwt2.org/atlas/sw/ACE/current
#[[ -z "${connectCVMFSaceImage}" ]] && export connectCVMFSaceImage=/cvmfs/cernvm-prod.cern.ch/cvm3

# Location of the OSG WN Client if connectUseCVMFSaceWNCtb is not defined
[[ -z "${connectCVMFSaceWNC}" ]] && export connectCVMFSaceWNC=/cvmfs/osg.mwt2.org/osg/sw

# Location of the Certificate Authority if connectUseCVMFSaceCAtb is not defined
[[ -z "${connectCVMFSaceCA}" ]] && export connectCVMFSaceCA=/cvmfs/osg.mwt2.org/osg/CA


#########################################################################################
# Additional CVMFS repositories not provided by default in Parrot 
#########################################################################################

# Repository keys
export cvmfsKeyCERN="${connectHome}/cern.ch.pub"
export cvmfsKeyMWT2="${connectHome}/osg.mwt2.org.pub"

# CERN Production repository "cernvm-prod.cern.ch"
export cvmfsRepoCERNVM="cernvm-prod.cern.ch:url=http://cvmfs-stratum-one.cern.ch/opt/cernvm-prod;http://cernvmfs.gridpp.rl.ac.uk/opt/cernvm-prod;http://cvmfs.racf.bnl.gov/opt/cernvm-prod,pubkey=${cvmfsKeyCERN},proxies=${cvmfsProxy}"

# CERN Geant4
export cvmfsRepoGEANT4="geant4.cern.ch:url=http://cvmfs-stratum-one.cern.ch/opt/geant4;http://cernvmfs.gridpp.rl.ac.uk/opt/geant4;http://cvmfs.racf.bnl.gov/opt/geant4,pubkey=${cvmfsKeyCERN},proxies=${cvmfsProxy}"

# MidWest Tier2 repository "osg.mwt2.org"
export cvmfsRepoMWT2="osg.mwt2.org:url=http://uct2-cvmfs.mwt2.org/opt/osg;http://iut2-cvmfs.mwt2.org/opt/osg;http://mwt2-cvmfs.campuscluster.illinois.edu/opt/osg,pubkey=${cvmfsKeyMWT2},proxies=${cvmfsProxy}"


# The repositories we will use
export cvmfsRepoList="${cvmfsRepoMWT2} ${cvmfsRepoCERNVM} ${cvmfsRepoGEANT4}"


#########################################################################################
# Location of ConnectWrapper executeables, libraries and such
#########################################################################################

# Some executables we need
export connectBIN="${connectHome}/bin"


# Add anything missing to $PATH
f_addpath "/usr/bin"
f_addpath "/bin"
f_addpath "/usr/sbin"
f_addpath "/sbin"


# Extra Libraries needed
export connectLIB="${connectHome}/lib64:${connectHome}/lib"

# Add the local libraries to the library path
f_addldlibrarypath "${connectLIB}"


# Extra Python modules needed
export connectPYTHONPATH="${connectHome}/python"

# Add the local python modules to the Python path
f_addpythonpath "${connectPYTHONPATH}"


#########################################################################################
# Parrot Run definitions
#########################################################################################

# Parrot Helper location
export PARROT_HELPER="${connectHome}/\$LIB/libparrot_helper.so"

# Get the version of Parrot we are running
export connectParrotVersion=$(echo $(${connectBIN}/parrot_run --version) | cut -f3 -d' ')

# Hopefully CCTools will define $PARROT_VERSION in a future release
[[ -z "${PARROT_VERSION}" ]] && export PARROT_VERSION=${connectParrotVersion}



# If we are using a Chirp Server to access the CVMFS repositories,
# enabled the "auth" and map all references to /cvmfs into /chirp on the Chirp Server

if [[ -n "${connectUseParrotChirp}" ]]; then
  export connectParrotRunChirp="--block-size ${connectParrotChirpBlocksize} --chirp-auth hostname --mount /cvmfs=/chirp/${connectParrotChirpServer}"
fi



# Should we enable the Thread Clone Bugfix (only support in select version of Parrot)
# This will most likely have severe impact on the performance of the job

if [[ -n "${connectUseThreadCloneFix}" ]]; then
  if [[ "${connectParrotVersion}" == "4.1.4rc5-TRUNK" ]]; then
    export connectParrotRunCVMFS="--cvmfs-enable-thread-clone-bugfix"
  fi
fi


#########################################################################################
# Connect Cache definitions
#########################################################################################

# Location of Connect Root with a default to /tmp
[[ -z ${connectRoot} ]] && export connectRoot=/tmp

# Full path to the Connect cache for all users on this node
export connectCacheRoot=${connectRoot}/connectCache

# Each user has a private cache which will be rolled daily
export connectCacheUserRoot=${connectCacheRoot}.$(whoami)

# Create the User Root 
mkdir -p ${connectCacheUserRoot}; chmod 700 ${connectCacheUserRoot}

# Due to Cache Bloat, we will roll the cache daily per user
export connectCacheDailyRoot=${connectCacheUserRoot}/$(date +%Y%m%d)

# Create the Daily Cache location
mkdir -p ${connectCacheDailyRoot}; chmod 700 ${connectCacheDailyRoot}

# Location of the Parrot and CVMFS alien caches
export connectParrotCache=${connectCacheDailyRoot}/parrotCache

# Create the Parrot Cache location
mkdir -p ${connectParrotCache}; chmod 700 ${connectParrotCache}


#########################################################################################
# ACE Cache definitions
#########################################################################################

# Location of the ACE Root with a default to where the Connect Cache is located
[[ -z ${aceRoot} ]] && export aceRoot=${connectRoot}

# Full path to the ACE cache for all users on this node
export aceCacheRoot=${aceRoot}/aceCache

# Each user has a private cache which will be rolled daily
export aceCacheUserRoot=${aceCacheRoot}.$(whoami)

# Create the User Root 
mkdir -p ${aceCacheUserRoot}; chmod 700 ${aceCacheUserRoot}

# To pick up any changes, roll the cache daily
export aceCacheDailyRoot=${aceCacheUserRoot}/$(date +%Y%m%d)

# Create the Daily Cache location
mkdir -p ${aceCacheDailyRoot}; chmod 700 ${aceCacheDailyRoot}

# Make the Daily Cache the active location
export aceCache=${aceCacheDailyRoot}



# Location of the CA

if [[ -n "${connectUseCVMFSaceCAtb}" ]]; then
  export aceCA=${aceCache}/CA
else
  export aceCA=${connectCVMFSaceCA}
fi


# Location of the ACE OSG WN Client

if [[ -n "${connectUseCVMFSaceWNCtb}" ]]; then
  export aceWNC=${aceCache}/osg
else
  export aceWNC=${connectCVMFSaceWNC}
fi


# Location of the ACE Image (CVMFS or the ACE Cache)

if [[ -n "${connectUseCVMFSaceImageTB}" ]]; then
  export aceImage=${aceCache}/ACE
else
  export aceImage=${connectCVMFSaceImage}
fi


# Location of the ACE etc
export aceEtc=${aceCache}/etc

# Location of the ACE etc
export aceVar=${aceCache}/var


#########################################################################################
# Start of execution
#########################################################################################

echo "################################################################################"

# Display the Connect Wrapper to help us debug
f_echo "Connect Wrapper Version ${connectWrapperVersion}"
f_echo "Connect Cache             = ${connectCacheDailyRoot}"
f_echo "CVMFS Access Type         = ${cvmfsType}"

if [[ -n "${connectUseNativeONLY}" ]]; then
  f_echo "CVMFS Repository Access   = Native CVMFS"
elif [[ -n "${connectUseNfsCVMFS}" ]]; then
  f_echo "CVMFS Repository Access   = nfsCVMFS"
  f_echo "CVMFS Mount               = ${cvmfsMount}"
elif [[ -n "${connectUsePortableCVMFS}" ]]; then
  f_echo "CVMFS Repository Access   = PortableCVMFS"
  f_echo "CVMFS Mount               = ${cvmfsMount}"
  f_echo "CVMFS Proxy               = ${cvmfsProxy}"
  f_echo "CVMFS Scratch             = ${cvmfsScratch}"
  f_echo "CVMFS Cache Quota         = ${cvmfsQuota}"
elif [[ -n "${connectUseParrotCVMFS}" ]]; then

  if [[ -n "${connectUseParrotChirp}" ]]; then
    f_echo "CVMFS Repository Access   = Parrot/Chirp Version ${connectParrotVersion}"
    f_echo "Chirp Server              = ${connectParrotChirpServer}"
    f_echo "Chirp Server Blocksize    = ${connectParrotChirpBlocksize}"
    f_echo "ParrotRunChirp            = ${connectParrotRunChirp}"
  else
    f_echo "CVMFS Repository Access   = Parrot/CVMFS Version ${connectParrotVersion}"
    f_echo "CVMFS Proxy               = ${cvmfsProxy}"
  fi

  f_echo "Parrot Proxy              = ${connectParrotProxy}"
  f_echo "Parrot Cache              = ${connectParrotCache}"

  if [[ -n "${connectUseParrotMount}" ]]; then
    f_echo "Parrot Mount              = Enabled"
  else
    f_echo "Parrot Mount              = Disabled"
  fi

  f_echo "ParrotRunCVMFS            = ${connectParrotRunCVMFS}"

else
  f_echo "CVMFS Repository Access   = *Unknown*"
fi


f_echo "Kernel                    = $(uname --kernel-release)"

if [[ -n "${connectUseNativeONLY}" ]]; then
  f_echo "ACE Cache                 = Disabled"
else
  f_echo "ACE Cache                 = ${aceCache}"
  f_echo "ACE Certificate Authority = ${aceCA}/certificates"
  f_echo "ACE Worker Node Client    = ${aceWNC}/osg-wn-client"
  f_echo "ACE Image                 = ${aceImage}"

  # ACE etc and var are only needed if we are using Parrot for CVMFS access
  if [[ -n "${connectUseParrotCVMFS}" ]]; then
    f_echo "ACE etc                   = ${aceEtc}"
    f_echo "ACE var                   = ${aceVar}"
  fi

  if [[ -n "${connectUseSystemLIB}" ]]; then
    f_echo "ACE Image Libraries       = Disabled"
  else
    f_echo "ACE Image Libraries       = Enabled"
  fi
fi


f_echo "Frontier Server URL       = ${connectFrontierServerURL}"
f_echo "Frontier Proxy  URL       = ${connectFrontierProxyURL}"


#########################################################################################
# Setup the ulimits for this job
#########################################################################################

# Fill in some defaults we would like to use

[[ -z "${ulimitOpenFiles}"   ]] && ulimitOpenFiles=65536
[[ -z "${ulimitStackSize}"   ]] && ulimitStackSize=unlimited
[[ -z "${ulimitMaxUserProc}" ]] && ulimitMaxUserProc=unlimited


# Set the various ulimits for the job using any values set in site.conf

f_ulimit -t  hard ${ulimitCPU}
f_ulimit -d  hard ${ulimitDataSeg}
f_ulimit -f  hard ${ulimitFileSize}
f_ulimit -l  hard ${ulimitMaxLockMem}
f_ulimit -n  hard ${ulimitOpenFiles}
f_ulimit -s  hard ${ulimitStackSize}
f_ulimit -m  hard ${ulimitMaxMem}
f_ulimit -u  hard ${ulimitMaxUserProc}
f_ulimit -v  hard ${ulimitVirMem}
f_ulimit -x  hard ${ulimitFileLocks}

#f_ulimit -c hard      ${ulimitCoreFileSize}
#f_ulimit -e hard      ${ulimitSchedPrio}
#f_ulimit -i hard      ${ulimitPendSig}
#f_ulimit -p hard      ${ulimitPipeSize}
#f_ulimit -q hard      ${ulimitPOSIXMesQ}
#f_ulimit -r hard      ${ulimitRTPrio}

f_echo
f_echo "Executing command: ulimit -S -a"
f_echo

ulimit -S -a

f_echo


#########################################################################################
# Cleanup old Connect and ACE Cache directories
#########################################################################################

# First clean out old Daily Caches in case we need the space

f_echo "Requesting a lock for the Connect Cache"

# Lock the Connect Cache User Root to only allow one job to cleanup with a 1 hour timeout on the lock
${connectBIN}/lockfile -0 -r 0 -s 0 -l $((60*60)) ${connectCacheUserRoot}.lock 2> /dev/null

# Proceed only if we got the lock
if [[ $? -ne 0 ]]; then
  f_echo "Connect Cache locked - Skipping purge of old Connect Caches"
else

  f_echo "Purge Connect Cache from ${connectCacheUserRoot}"

  # If we exit too soon try to cleanup the lock
  trap "rm -f ${connectCacheUserRoot}.lock; exit" ${connectTRAP}

  # Cleanup the Connect User Cache area of any directories older than 7 days
  find  ${connectCacheUserRoot}/* -ignore_readdir_race -maxdepth 0 -xdev -atime +7 -type d -exec rm -rf {} \;

  f_echo "Purge Connect Cache complete"

  f_echo "Releasing the lock on the Connect Cache"
  rm -f ${connectCacheUserRoot}.lock

  # Clear the traps since we are now done
  trap - ${connectTRAP}

fi


f_echo "Requesting a lock for the ACE Cache"

# Lock the ACE Cache User Root to only allow one job to cleanup with a 1 hour timeout on the lock
${connectBIN}/lockfile -0 -r 0 -s 0 -l $((60*60)) ${aceCacheUserRoot}.lock 2> /dev/null

# Proceed only if we got the lock
if [[ $? -ne 0 ]]; then
  f_echo "ACE Cache locked - Skipping purge of old ACE Caches"
else

  f_echo "Purge ACE Cache from ${aceCacheUserRoot}"

  # If we exit too soon try to cleanup the lock
  trap "rm -f ${aceCacheUserRoot}.lock; exit" ${connectTRAP}

  # Cleanup the ACE User Cache area of any directories older than 7 days
  find  ${aceCacheUserRoot}/* -ignore_readdir_race -maxdepth 0 -xdev -atime +7 -type d -exec rm -rf {} \;

  f_echo "Purge ACE Cache complete"

  f_echo "Releasing the lock on the ACE Cache"
  rm -f ${aceCacheUserRoot}.lock

  # Clear the traps since we are now done
  trap - ${connectTRAP}

fi


#########################################################################################
# Setup the ACE Image
#########################################################################################

# Setup the Atlas Compliant Environment (ACE) Image unless we are to use the System libraries

if [[ -z "${connectUseSystemLIB}" ]]; then

  source ${connectHome}/setup_ace.sh

  # Save the ACE installation status
  aceStatus=$?

  if [[ ${aceStatus} -ne 0 ]]; then
     f_echo
     f_echo "Aborting job: Unable to setup the ACE Image with error ${aceStatus}"
     f_echo
     exit ${aceStatus}
  fi

fi


#########################################################################################
# Setup the ACE OSG WN Client
#########################################################################################

# Setup OSG WN Client, useless we are using NativeONLY

if [[ -z "${connectUseNativeONLY}" ]]; then

  source ${connectHome}/setup_osg.sh

  # Save the ACE installation status
  osgStatus=$?

  if [[ ${osgStatus} -ne 0 ]]; then
     f_echo
     f_echo "Aborting job: Unable to setup the ACE OSG WN Client with error ${osgStatus}"
     f_echo
     exit ${osgStatus}
  fi

fi


#########################################################################################
# Setup the Certificate Authority
#########################################################################################

# Setup or update the ACE Certifiate Authority unless we are Native Only

if [[ -z "${connectUseNativeONLY}" ]]; then

  source ${connectHome}/setup_ca.sh

  # Save the ACE CA installation status
  caStatus=$?

  if [[ ${caStatus} -ne 0 ]]; then
     f_echo
     f_echo "Aborting job: Unable to setup the ACE Certificate Authority with error ${aceStatus}"
     f_echo
     exit ${caStatus}
  fi

fi


#########################################################################################
# Define OSG variables normally setup on a CE
#########################################################################################

# OSG_APP, OSG_GRID and OSG_WN_TMP are defined here. All other Pilot variables are defined in the APF


# Use a local $OSG_APP as defined by the system or site.conf
# Otherwise use the $OSG_APP included with the ConnectWrapper

if [[ -n "${connectUseNativeONLY}" ]]; then

  # If the system has not defined a $OSG_APP, use the one in the ConnectWrapper

  if [[ -z "${OSG_APP}" ]]; then
    export OSG_APP=${connectHome}/OSG_APP
    export ATLAS_LOCAL_AREA=${OSG_APP}/atlas_app/local
  fi

else

  # For most CVMFS Access Types, always use a $OSG_APP packaged with ConnectWrapper

  export OSG_APP=${connectHome}/OSG_APP
  export ATLAS_LOCAL_AREA=${OSG_APP}/atlas_app/local

fi

f_echo "\$OSG_APP                  = ${OSG_APP}"
f_echo "\$ATLAS_LOCAL_AREA         = ${ATLAS_LOCAL_AREA}"


# Use a local $OSG_GRID (OSG WN Client) as defined by the system or site.conf
# Otherwise use a $OSG_GRID (OSG WN Client) from the ACE Cache as installed by setup_ace.sh

if [[ -z "${connectUseNativeONLY}" ]]; then
  export OSG_GRID=${aceWNC}/osg-wn-client
fi

if [[ -n "${OSG_GRID}" ]]; then
  f_echo "\$OSG_GRID                 = ${OSG_GRID}"
else
  f_echo "\$OSG_GRID                 = *SYSTEM*"
fi


# Use the specified worker node temp area

if [[ -n ${_condor_LOCAL_DIR} ]]; then
  export OSG_WN_TMP=${_condor_LOCAL_DIR}/scratch
else
  export OSG_WN_TMP=${aceCache}/scratch
fi

# Make certain the OSG WN scratch exists
mkdir -p ${OSG_WN_TMP}

f_echo "\$OSG_WN_TMP               = ${OSG_WN_TMP}"


# Define a proxy to use

if [[ -n "${connectUseNativeONLY}" ]]; then
  f_echo "\$HTTP_PROXY               = *SYSTEM*"
else
  export HTTP_PROXY=${connectParrotProxy}
  f_echo "\$HTTP_PROXY               = ${HTTP_PROXY}"
fi



# Default Certificate Authority (osg-wn-client may override this value)

if [[ -n "${connectUseNativeONLY}" ]]; then
  f_echo "\$X509_CERT_DIR            = *SYSTEM*"
else
  export X509_CERT_DIR=${aceCA}/certificates
  f_echo "\$X509_CERT_DIR            = ${X509_CERT_DIR}"
fi


# DQ2 uses $USER to create a unique /var/tmp/.dq2$USER/TiersOfAtlas.py
[[ -z $USER ]] && export USER=$(whoami)


#########################################################################################
# Make a unique Parrot cache for every job
#########################################################################################

# Make a unique location for job due to Parrot bugs
# We remove this tmp cache at job end (see below)

if [[ -n "${connectUsePrivateParrotCache}" ]]; then
  export connectParrotCache=$(mktemp -d -p ${connectParrotCache} tmp.XXX)
  f_echo "Private Parrot Cache      = ${connectParrotCache}"
fi


#########################################################################################
# Redirect the various Temporary paths to avoid long paths
#########################################################################################

# Create some softlinks to $TMP, $TEMP and $TMPDIR to shorten the paths to fix the error
#
#	AF_UNIX path too long

# Create a container for the soflinks for this job
#export connectCacheTMP=$(mktemp -d -p ${connectCacheDailyRoot} .XXX)
#export connectCacheTMP=$(mktemp -d -p ${connectCacheUserRoot} .XXX)
export connectCacheTMP=$(mktemp -d -p ${connectRoot} tmpCache.XXX)

f_echo "TMP Redirection Cache     = ${connectCacheTMP}"

# Create some defaults for these
[[ -z "${TMP}"    ]] && export TMP=${OSG_WN_TMP}
[[ -z "${TEMP}"   ]] && export TEMP=${OSG_WN_TMP}
[[ -z "${TMPDIR}" ]] && export TMPDIR=${OSG_WN_TMP}

# Redirect the path via a softlink saving the old for a restore later
OLD_TMP=${TMP}       ; export TMP=${connectCacheTMP}/TMP       ; ln -s ${OLD_TMP}    ${TMP}
OLD_TEMP=${TEMP}     ; export TEMP=${connectCacheTMP}/TEMP     ; ln -s ${OLD_TEMP}   ${TEMP}
OLD_TMPDIR=${TMPDIR} ; export TMPDIR=${connectCacheTMP}/TMPDIR ; ln -s ${OLD_TMPDIR} ${TMPDIR}

#f_echo "Redirect TMP    to ${TMP}    from ${OLD_TMP}"
#f_echo "Redirect TEMP   to ${TEMP}   from ${OLD_TEMP}"
#f_echo "Redirect TMPDIR to ${TMPDIR} from ${OLD_TMPDIR}"


#########################################################################################
# And finally, are we Native or Run Parrot Run
#########################################################################################

f_echo

# Should we use Parrot or another way to access the CVMFS repositories

if [[ -z "${connectUseParrotCVMFS}" ]]; then

  if [[ -n "${connectUseNativeONLY}" ]]; then
    f_echo "Begin execution using Native CVMFS to access the repositories"
  elif [[ -n "${connectUseNfsCVMFS}" ]]; then
    f_echo "Begin execution using nfsCVMFS to access the repositories"
  elif [[ -n "${connectUsePortableCVMFS}" ]]; then
    f_echo "Begin execution using PortableCVMFS to access the repositories"
  fi

  echo "################################################################################"
  echo

  ${connectHome}/exec.sh "$@"

  # Save the return code from the user job
  wrapperRet=$?

else

  if [[ -n "${connectUseParrotChirp}" ]]; then
    f_echo "Begin execution within Parrot/Chirp ${connectParrotVersion} environment"
  else
    f_echo "Begin execution within Parrot/CVMFS ${connectParrotVersion} environment" 
  fi

  echo "################################################################################"
  echo


  # We redirect via --mount all bin, library, python and perl modules to the ACE Image

  if [[ -n "${connectUseParrotMount}" ]]; then

    # Execute the command in a Parrot-enabled bash subshell, mapping access into the ACE Image
    ${connectBIN}/parrot_run								\
	--with-snapshots 								\
	--timeout 900									\
	--tempdir "${connectParrotCache}"						\
	--proxy   "${connectParrotProxy}"						\
        --mount /bin=${aceImage}/bin                                                    \
        --mount /sbin=${aceImage}/sbin                                                  \
        --mount /lib=${aceImage}/lib                                                    \
        --mount /lib64=${aceImage}/lib64                                                \
        --mount /opt=${aceImage}/opt                                                    \
        --mount /root=${aceImage}/root                                                  \
        --mount /usr=${aceImage}/usr                                                    \
        --mount /etc=${aceImage}/etc                                                    \
        --mount /etc/passwd=${aceEtc}/passwd                                            \
        --mount /etc/group=${aceEtc}/group                                              \
        --mount /etc/hosts=/etc/hosts                                                   \
        --mount /etc/resolv.conf=/etc/resolv.conf                                       \
	--mount /etc/fstab=/etc/fstab                                                   \
        --mount /etc/mtab=/etc/mtab                                                     \
        --mount /var=${aceVar}                                                          \
	--cvmfs-repo-switching 								\
	--cvmfs-repos "<default-repositories> ${cvmfsRepoList}"				\
        ${connectParrotRunCVMFS}							\
        ${connectParrotRunChirp}							\
		${connectHome}/exec.sh "$@"

    # Save the return code from the user job
    wrapperRet=$?

  else

    # Execute the command in a Parrot-enabled bash subshell 
    ${connectBIN}/parrot_run								\
	--with-snapshots 								\
	--timeout 900									\
	--tempdir "${connectParrotCache}"						\
	--proxy   "${connectParrotProxy}"						\
	--cvmfs-repo-switching 								\
	--cvmfs-repos "<default-repositories> ${cvmfsRepoList}"				\
        ${connectParrotRunCVMFS}							\
        ${connectParrotRunChirp}							\
		${connectHome}/exec.sh "$@"

    # Save the return code from the user job
    wrapperRet=$?

  fi
fi

#########################################################################################

echo
echo "################################################################################"


#########################################################################################
# Restore the original TMP paths
#########################################################################################

# Restore the old TMP paths and remove the softlinks

#f_echo "Restoring old values to TMP, TEMP and TMPDIR"

# Restore the old values
export TMP=${OLD_TMP}
export TEMP=${OLD_TEMP}
export TMPDIR=${OLD_TMPDIR}

# Remove the TMP softlinks cache dirctory
f_echo "Removing TMP Redirection Cache located at ${connectCacheTMP}"
rm -rf ${connectCacheTMP}


#########################################################################################
# If we used a private Parrot Cache, clean it up
#########################################################################################

# Remove the Per Job Private Parrot Cache

if [[ -n "${connectUsePrivateParrotCache}" ]]; then
  f_echo "Removing Private Parrot Cache located at ${connectParrotCache}"
  rm -rf ${connectParrotCache}
fi


#########################################################################################

f_echo "End of Connect Wrapper Version ${connectWrapperVersion}"

echo "################################################################################"

#########################################################################################

# Exit with the return code from the user job
exit ${wrapperRet}
