#!/bin/bash

# Local site definitions for the ConnectWrapper

####################################################################


# Frontier Server URL
if [[ -n "${_RCC_FrontierServerURL}" ]]; then
  export connectFrontierServerURL="${_RCC_FrontierServerURL}"
else
  export connectFrontierServerURL="${_DF_connectFrontierServerURL}"
fi


# Frontier Proxy URL
if [[ -n "${_RCC_FrontierProxyURL}" ]]; then
  export connectFrontierProxyURL="${_RCC_FrontierProxyURL}"
else
  export connectFrontierProxyURL="${_DF_connectFrontierProxyURL}"
fi


# Frontier Server
export FRONTIER_SERVER="${connectFrontierServerURL}${connectFrontierProxyURL}"


# HTTP Proxy Servers
if [[ -n "${_RCC_HTTPProxy}" ]]; then
  export connectHTTPProxy="${_RCC_HTTPProxy}"
else
  export connectHTTPProxy="${_DF_connectHTTPProxy}"
fi


# Connect Cache Root Location
if [[ -n "${_RCC_ConnectScratch}" ]]; then
  export connectRoot="${_RCC_ConnectScratch}"
else
  export connectRoot="${_DF_connectRoot}"
fi


# ACE Root Location
if [[ -n "${_RCC_Scratch}" ]]; then
  export aceRoot="${_RCC_Scratch}"
else
  export aceRoot="${_DF_aceRoot}"
fi


####################################################################


# Parrot definitions

# Parrot Proxy Servers
if [[ -n "${_RCC_ParrotProxy}" ]]; then
  export connectParrotProxy="${_RCC_ParrotProxy}"
else
  export connectParrotProxy="${_DF_connectParrotProxy}"
fi

# The Chirp Server upon which the CVMFS repositories are statically mounted and accessible
[[ -z "${connectParrotChirpServer}" ]] && export connectParrotChirpServer="${_DF_connectParrotChirpServer}"

# The blocksize to use for Parrot/Chirp, 1M or 2M
[[ -z "${connectParrotChirpBlocksize}" ]] && export connectParrotChirpBlocksize="${_DF_connectParrotChirpBlocksize}"


####################################################################


# CVMFS definitions

# CVMFS Type
if [[ -n "${_RCC_CVMFS}" ]]; then
  export cvmfsType="${_RCC_CVMFS}"
else
  export cvmfsType="${_DF_cvmfsType}"
fi


# CVMFS Proxy Servers (DIRECT)
if [[ -n "${_RCC_CVMFSProxy}" ]]; then
  export cvmfsProxy="${_RCC_CVMFSProxy};DIRECT"
else
  export cvmfsProxy="${connectHTTPProxy};DIRECT"
fi


# CVMFS Mount
if [[ -n "${_RCC_CVMFSMount}" ]]; then
  export cvmfsMount="${_RCC_CVMFSMount}"
else
  export cvmfsMount="${_DF_cvmfsMount}"
fi


# CVMFS Scratch
if [[ -n "${_RCC_CVMFSScratch}" ]]; then
  export cvmfsScratch="${_RCC_CVMFSScratch}"
else
  export cvmfsScratch="${_DF_cvmfsScratch}"
fi


# CVMFS Quota
if [[ -n "${_RCC_CVMFSQuota}" ]]; then
  export cvmfsQuota="${_RCC_CVMFSQuota}"
else
  export cvmfsQuota="${_DF_cvmfsQuota}"
fi


####################################################################


# CVMFS vs Tarball


# The server with all our tarballs
[[ -z "${connectTBaceHTTP}"  ]] && export connectTBaceHTTP="${_DF_connectTBaceHTTP}"

# ACE Image tarball
[[ -z "${connectTBaceImage}" ]] && export connectTBaceImage="${_DF_connectTBaceImage}"

# ACE OSG Worker Node Client (WNC) tarball
[[ -z "${connectTBaceWNC}"   ]] && export connectTBaceWNC="${_DF_connectTBaceWNC}"



# ACE Image

if   [[ ${_RCC_UseTBace} == 'true'  ]]; then
  export connectUseTBaceImage='true'
elif [[ ${_RCC_UseTBace} == 'false' ]]; then
  export connectUseTBaceImage=''
else
  export connectUseTBaceImage="${_DF_connectUseTBaceImage}"
fi

# Location of the ACE Image if connectUseTBaceImage is not defined
[[ -z "${connectCVMFSaceImage}" ]] && export connectCVMFSaceImage="${_DF_connectCVMFSaceImage}"


# OSG Worker Node Client

if   [[ ${_RCC_UseTBace} == 'true'  ]]; then
  export connectUseTBaceWNC='true'
elif [[ ${_RCC_UseTBace} == 'false' ]]; then
  export connectUseTBaceWNC=''
else
  export connectUseTBaceWNC="${_DF_connectUseTBaceWNC}"
fi

# Location of the OSG WN Client if connectUseTBaceWNC is not defined
[[ -z "${connectCVMFSaceWNC}" ]] && export connectCVMFSaceWNC="${_DF_connectCVMFSaceWNC}"


# Certificate Authority

if   [[ ${_RCC_UseTBace} == 'true'  ]]; then
  export connectUseTBaceCA='true'
elif [[ ${_RCC_UseTBace} == 'false' ]]; then
  export connectUseTBaceCA=''
else
  export connectUseTBaceCA="${_DF_connectUseTBaceCA}"
fi

# Location of the Certificate Authority if connectUseTBaceCA is not defined
[[ -z "${connectCVMFSaceCA}" ]] && export connectCVMFSaceCA="${_DF_connectCVMFSaceCA}"



####################################################################


# For CVMFS Access Type "native", we will provide some defaults used by MWT2

# Use a local $OSG_APP
if [[ -n "${_RCC_OSG_APP}" ]]; then
  export OSG_APP="${_RCC_OSG_APP}"
else
  export OSG_APP="${_DF_OSG_APP}"
fi

# Use a local OSG WN Client
if [[ -n "${_RCC_OSG_GRID}" ]]; then
  export OSG_GRID="${_RCC_OSG_GRID}"
else
  export OSG_GRID="${_DF_OSG_GRID}"
fi


####################################################################
