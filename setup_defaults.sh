#!/bin/bash

######################################################################################


# The version of the wrapper
export connectWrapperVersion="4.5-2"


######################################################################################
# NativeCVMFS, nfsCVMFS, ReplicaCVMFS, PortableCVMFS, ParrotCVMFS or ParrotChirp Wrapper
######################################################################################
# 
#
# The following variables will modify the action taken by the Connect Wrapper
# 
# These should be set in the site.conf script based on the requirements of the site
#
# At the minimum, $cvmfsType should be defined to one of the following values
#
# 	native		Use System installed CVMFS             Use HEPOS_libs and Certificate Authority
#	nfs		Use System installed nfsCVMFS          ACE Cache available
#	replica		Use System installed ReplicaCVMFS      ACE Cache available
#	portable	Use PortableCVMFS                      ACE Cache available
#	parrot		Use ParrotCVMFS                        ACE Cache available
#
# Default value for $cvmfsType is "native"
#
#
# The ACE Cache contains and ACE Image (for HEPOS_lib), OSG WN Client and a Certicate Authority
# The ACE Cache componitents can be local (default tarball installation) or a CVMFS repository
# The ACE Image can be bypassed and the System libraries used
#
# If ParrotCVMFS is used, Parrot can "mount" access into the ACE Image
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
#	$OSG_APP	Defined by the system or within setup_site
#	$OSG_GRID	Defined by the system or within setup_site
#	$OSG_WN_TMP	Setup by this wrapper within the job sandbox
#	$X509_CERT_DIR	Defined by the system or within setup_site or a CA at /etc/grid-security/certificates
#
#export connectUseNativeONLY=True


# If connectUseClientCVMFS is defined, use ClientCVMFS to access all /cvmfs repositories
# By default, it is assume that /cvmfs is mounted locally via a locally installed CVMFS Client RPM
# The wrapper will setup access to an ACE Image (via env var), OSG WN Client and Certficate Authority
#export connectUseClientCVMFS=True


# If connectUseNfsCVMFS is defined, use nfsCVMFS to access all /cvmfs repositories
# By default, it is assume that /cvmfs is mounted locally via NFS
# The wrapper will setup access to an ACE Image (via env var), OSG WN Client and Certficate Authority
#export connectUseNfsCVMFS=True


# If connectUseReplicaCVMFS is defined, use ReplicaCVMFS to access all /cvmfs repositories
# By default, it is assume that /cvmfs is mounted locally via replicated repositories from a Stratum-R
# The wrapper will setup access to an ACE Image (via env var), OSG WN Client and Certficate Authority
#export connectUseReplicaCVMFS=True


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


# If connectUseTBaceImage is defined, we will use an ACE Image from a Tarball installed in the ACE Cache
# By default, an ACE Image from a CVMFS repository will be used
#export connectUseTBaceImage=True


# If connectUseTBaceWNC is defined, we will use the OSG WN Client from a Tarball installed in the ACE Cache
# By default, the OSG WNC Client from a CVMFS repository will be used
#export connectUseTBaceWNC=True


# If connectUseTBaceCA is defined, we will use a Certificate Authority from an installation in the ACE Cache
# By default, a Certificate Authority from a CVMFS repoisitory will be used
#export connectUseTBaceCA=True


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


# Location of the ACE Image if connectUseTBaceImage is not defined
#export connectCVMFSaceImage=/cvmfs/osg.mwt2.org/atlas/sw/ACE/current
#export connectCVMFSaceImage=/cvmfs/cernvm-prod.cern.ch/cvm3


# Location of the OSG WN Client if connectUseTBaceWNC is not defined
#export connectCVMFSaceWNC=/cvmfs/osg.mwt2.org/osg/sw


# Location of the Certificate Authority repository if connectUseTBaceCA is not defined
#export connectCVMFSaceCA=/cvmfs/osg.mwt2.org/osg/CA



######################################################################################
# Default values 
######################################################################################


# Default CVMFS Type
export _DF_cvmfsType="undefined"


######################################################################################


# ACE Image defaults

# Default use of Image Tarball
export _DF_connectUseTBaceImage=

# Default location of the ACE Image if connectUseTBaceImage is not defined
export _DF_connectCVMFSaceImage="/cvmfs/osg.mwt2.org/atlas/sw/ACE/current"
#export _DF_connectCVMFSaceImage="/cvmfs/cernvm-prod.cern.ch/cvm3"


# Default use of OSG WN Client tarball
export _DF_connectUseTBaceWNC=

# Default location of the OSG WN Client if connectUseTBaceWNC is not defined
export _DF_connectCVMFSaceWNC="/cvmfs/osg.mwt2.org/osg/sw"


# Default use of Certificate Authority Tarball
export _DF_connectUseTBaceCA=

# Default location of the Certificate Authority if connectUseTBaceCA is not defined
export _DF_connectCVMFSaceCA="/cvmfs/osg.mwt2.org/osg/CA"


# Server with all the tarballs
export _DF_connectTBaceHTTP="http://rccf.usatlas.org"

# ACE Image tarball
export _DF_connectTBaceImage="ace.tar.gz"

# ACE OSG Worker Node Client (WNC) tarball
export _DF_connectTBaceWNC="osg-wn-client.tar.gz"


######################################################################################


# Frontier Server Definitions

export _DF_connectFrontierServerURL='(serverurl=http://frontier-atlas.lcg.triumf.ca:3128/ATLAS_frontier)(serverurl=http://frontier-atlas1.lcg.triumf.ca:3128/ATLAS_frontier)(serverurl=http://tier1nfs.triumf.ca:3128/ATLAS_frontier)(serverurl=http://frontier.triumf.ca:3128/ATLAS_frontier)(serverurl=http://ccfrontier.in2p3.fr:23128/ccin2p3-AtlasFrontier)(serverurl=http://ccsqfatlasli02.in2p3.fr:23128/ccin2p3-AtlasFrontier)(serverurl=http://ccsqfatlasli01.in2p3.fr:23128/ccin2p3-AtlasFrontier)'

export _DF_connectFrontierProxyURL="(proxyurl=http://uct2-squid.mwt2.org:3128)"


######################################################################################


# Default HTTP Proxy
export _DF_connectHTTPProxy="http://uct2-squid.mwt2.org:3128"


######################################################################################


# Connect Cache defaults

# Default location of Connect Root with a default to /tmp
export _DF_connectRoot="/tmp"


######################################################################################


# Connect Cache defaults

# Default location of ACE Root with a default to /tmp
export _DF_aceRoot="${_DF_connectRoot}"


######################################################################################


# CVMFS defaults

# CVMFS Mount point
export _DF_cvmfsMount="/cvmfs"

# CVMFS scratch (cache)
export _DF_cvmfsScratch="/tmp"

# CVMFS cache quota
export _DF_cvmfsQuota="25000"


######################################################################################


# $OSG_XXX defaults

# Default Use a local $OSG_APP
#export _DF_OSG_APP=/share/osg/mwt2/app/atlas_app
export _DF_OSG_APP=""

# Default OSG WN Client
#export _DF_OSG_GRID=/share/wn-client
export _DF_OSG_GRID=""


######################################################################################


# Parrot defaults

# Default Chirp Server
export _DF_connectParrotChirpServer="uct2-int.mwt2.org"
#export _DF_connectParrotChirpServer="uct2-c320.mwt2.org"

# Default Chirp blocksize (2M or 1M)
export _DF_connectParrotChirpBlocksize=2097152
#export _DF_connectParrotChirpBlocksize=1048576

# Default Parrot Proxy
export _DF_connectParrotProxy="http://uct2-squid.mwt2.org:3128"


######################################################################################
