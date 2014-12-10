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


# Parrot Proxy Servers
if [[ -n "${_RCC_ParrotProxy}" ]]; then
  export connectParrotProxy="${_RCC_ParrotProxy}"
else
  export connectParrotProxy="${_DF_connectParrotProxy}"
fi


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
  export cvmfsProxy="${connectParrotProxy};DIRECT"
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
