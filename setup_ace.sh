#!/bin/bash

#########################################################################################
#
# Setup the Atlas Compliant Environment (ACE) Image
#
#########################################################################################
# We need to make a shared copy of the Atlas Compliant Environment (ACE) Image
# The ACE Image resides in the ACE Cache User Root to be shared by all jobs of the same user
# We use "wget" to fetch all tarballs from the RCCF server
# To prevent collisions, we lock other jobs to create an atomic update
#########################################################################################

# The server with all our tarballs
aceHTTP=http://rccf.usatlas.org

# ACE Image tarball
aceImageTB=ace.tar.gz


# ACE library path
aceImageLIB="${aceImage}/usr/lib64:${aceImage}/lib64:${aceImage}/usr/lib:${aceImage}/lib"

# ACE binary path
aceImageBIN="${aceImage}/usr/bin:${aceImage}/bin:${aceImage}/usr/sbin:${aceImage}/sbin"

# ACE python libraries path
aceImagePython="${aceImage}/usr/lib64/python2.6/site-packages:${aceImage}/usr/lib/python2.6/site-packages"

# ACE perl modules path
aceImagePerl="${aceImage}/usr/share/perl5/vendor_perl:${aceImage}/usr/share/perl5"

# ACE C include path
aceImageCInclude="${aceImage}/usr/include"



# ACE Time Stamp
aceImageTS=${aceImage}/.acelastupdate

# ACE etc Time Stamp
aceEtcTS=${aceEtc}/.acelastupdate

# ACE var Time Stamp
aceVarTS=${aceVar}/.acelastupdate


# How we will sync the parts within ACE
aceRsync="/usr/bin/rsync --quiet --delete --ignore-errors --archive --no-owner --chmod=Dugo=rwx,-s"


#########################################################################################
# Use an ACE Image from /cvmfs or from a TarBall copied into the ACE Cache
#########################################################################################

# If we are using a CVMFS Image, we are done

if [[ -z "${connectUseCVMFSaceImageTB}" ]]; then
  f_echo "Using CVMFS based ACE Image from ${aceImage}"
else

  # Check to see if we need to update this area and get a lock if so 
  f_update_lock "${aceImage}" "${aceImageTS}" "ACE Image"

  # Save the status
  aceStatus=$?


  # Do we need to update this location

  if [[ ${aceStatus} -eq 0 ]]; then
    f_echo "Using existing ACE Image created on $(date -d @$(cat ${aceImageTS}) +%c)"
  else

    f_echo "Installation of the ACE Image from TarBall ${aceHTTP}/${aceImageTB}"
    f_echo "ACE Image will be located at ${aceImage}"

    # Remove any partial ACE that might be corrupt and start from scratch
    rm -rf ${aceImage}

    # Create the location for the ACE Image copy
    mkdir -p ${aceImage}

    # Pull down the current tarball from the osg area
    wget --quiet --directory-prefix=${aceImage} ${aceHTTP}/ace/${aceImageTB}

    # Save the status
    aceStatus=$?

    # Success or fail

    if [[ ${aceStatus} -ne 0 ]]; then
      f_echo "Unable to fetch the ACE Image TarBall with error ${aceStatus}"
    else

      # Unpack the ACE Image tarball into that location
      tar --extract --gzip --directory=${aceImage} --file=${aceImage}/${aceImageTB}

      # Save the tar status 
      aceStatus=$?

      # Success or fail

      if [[ ${aceStatus} -ne 0 ]]; then
        f_echo "Unable to install the ACE Image with error ${aceStatus}"
      else

        # Since we unpacked successfully, purge the tarball
        rm -f ${aceImage}/${aceImageTB}

        # Update the time stamp
        echo $(date +%s) > ${aceImageTS}

        # Completed successfully
        aceStatus=0

        f_echo "Installation of the ACE Image complete"

      fi
    fi


    # Success or failure of ACE Image installation

    if [[ ${aceStatus} -eq 0 ]]; then

      # ACE Image installed so we can remove the lock
      f_remove_lock "${aceImage}" "ACE Image"

    else

      # Remove the partial image
      rm -rf ${aceImage}

      # Remove the lock so others can now try
      f_remove_lock "${aceImage}" "ACE Image"

      # Return with the bad code
      return ${aceStatus}

    fi
  fi
fi


#########################################################################################
# Should we add all the ACE Image paths to ours
#########################################################################################


# Should we add map access to the ACE Image

if [[ -z "${connectUseSystemLIB}" ]]; then

  # Add the ACE Image binaries to the end of the path
  f_addpath "${aceImageBIN}"

  # Add the ACE Image Libraries to the loader path
  f_addldlibrarypath "${aceImageLIB}" ^

  # Add the ACE Image Libraries to the linker path
  f_addlibrarypath "${aceImageLIB}" ^

  # Add the ACE Image Python modules
  f_addpythonpath "${aceImagePython}" ^

  # Add the ACE Image Perl modules
   f_addperl5lib "${aceImagePerl}" ^

  # Add the ACE Image C Inlucde modules
   f_addcincludepath "${aceImageCInclude}" ^

fi



#########################################################################################
# Create the ACE etc (passwd, group)
#########################################################################################


# We only need an ACE etc if we are using Parrot to access /cvmfs

if [[ -n "${connectUseParrotCVMFS}" ]]; then

  # Check to see if we need to update this area and get a lock if so 
  f_update_lock "${aceEtc}" "${aceEtcTS}" "ACE etc"
 
  # Save the status
  aceStatus=$?


  # Do we need to update this location

  if [[ ${aceStatus} -eq 0 ]]; then
    f_echo "Using existing ACE etc created on $(date -d @$(cat ${aceEtcTS}) +%c)"
  else

    f_echo "Installation of the ACE etc from ACE Image at ${aceImage}"
    f_echo "ACE etc will be located at ${aceEtc}"

    # Remove any partial ACE etc that might be corrupt and start from scratch
    rm -rf ${aceEtc}

    # Create the location for the ACE etc
    mkdir -p ${aceEtc}


    # If we are using the Image from /cvmfs, we must use Parrot/CVMFS to access the source files

    if [[ -z "${connectUseCVMFSaceImageTB}" ]]; then

      # Use Parrot to fetch a copy of the etc directory
      ${connectBIN}/parrot_run						\
	--with-snapshots						\
	--timeout 900							\
	--tempdir "${connectParrotCache}"				\
	--proxy   "${connectParrotProxy}"				\
	--cvmfs-repo-switching						\
	--cvmfs-repos "<default-repositories> ${cvmfsRepoList}"		\
	${connectParrotRunCVMFS}					\
	${connectParrotRunChirp}					\
		${aceRsync} ${aceImage}/etc/   ${aceEtc}   2>/dev/null

      # Save the rsync return status
      etcStatus=$?

    else

      # Make a copy of the "etc" in the ACE Image (directories only) into a writable location
      ${aceRsync} ${aceImage}/etc/   ${aceEtc}   2>/dev/null

      # Save the rsync return status
      etcStatus=$?

    fi


    # Clear out a 23 which means we could not copy due to a permissions error
    [[ ${etcStatus} -eq 23 ]] && etcStatus=0


    # Did we setup the ACE etc

    if [[ ${etcStatus} -eq 0 ]]; then

      # Append the local user and group
      echo "$(id -un):x:$(id -u):$(id -g)::${HOME}:/sbin/nologin" >> ${aceEtc}/passwd
      echo "$(id -gn):x:$(id -g):"                                >> ${aceEtc}/group

      # Update the time stamp
      echo $(date +%s) > ${aceEtcTS}

      # ACE etc installed so we can remove the lock
      f_remove_lock "${aceEtc}" "ACE etc"

      f_echo "Installation of the ACE etc complete"

    else

      f_echo "RSYNC of the ACE etc failed with error ${etcStatus}"

      # Remove the partial image
      rm -rf ${aceEtc}

      # Clean the lock to allow the next guy to try again
      f_remove_lock "${aceEtc}" "ACE etc"

    fi
  fi
fi


#########################################################################################
# Create the ACE var in a writable area since the ACE Image many be read only
#########################################################################################


# We only need an ACE var if we are using Parrot to access /cvmfs

if [[ -n "${connectUseParrotCVMFS}" ]]; then

  # Check to see if we need to update this area and get a lock if so 
  f_update_lock "${aceVar}" "${aceVarTS}" "ACE var"
 
  # Save the status
  aceStatus=$?


  # Do we need to update this location

  if [[ ${aceStatus} -eq 0 ]]; then
    f_echo "Using existing ACE var created on $(date -d @$(cat ${aceVarTS}) +%c)"
  else

    f_echo "Installation of the ACE var from ACE Image at ${aceImage}"
    f_echo "ACE var will be located at ${aceVar}"

    # Remove any partial ACE var that might be corrupt and start from scratch
    rm -rf ${aceVar}
  
    # Create the location for the ACE var
    mkdir -p ${aceVar}


    # If we are using the Image from /cvmfs, we must use Parrot/CVMFS to access the source files

    if [[ -z "${connectUseCVMFSaceImageTB}" ]]; then

      # Use Parrot to fetch a copy of the var directory
      ${connectBIN}/parrot_run						\
	--with-snapshots						\
	--timeout 900							\
	--tempdir "${connectParrotCache}"				\
	--proxy   "${connectParrotProxy}"				\
	--cvmfs-repo-switching						\
	--cvmfs-repos "<default-repositories> ${cvmfsRepoList}"		\
	${connectParrotRunCVMFS}					\
	${connectParrotRunChirp}					\
		${aceRsync} --filter="+ */" --filter="- *"   ${aceImage}/var/   ${aceVar}   2>/dev/null

      # Save the rsync return status
      varStatus=$?

    else

      # Make a copy of the "var" in the ACE Image (directories only) into a writable location
      ${aceRsync} --filter="+ */" --filter="- *"   ${aceImage}/var/   ${aceVar}   2>/dev/null

      # Save the rsync return status
      varStatus=$?

    fi


    # Clear out a 23 which means we could not copy due to a permissions error
    [[ ${varStatus} -eq 23 ]] && varStatus=0

    # Did the rsync work

    if [[ ${varStatus} -eq 0 ]]; then

      # Update the time stamp
      echo $(date +%s) > ${aceVarTS}

      # ACE var installed so we can remove the lock
      f_remove_lock "${aceVar}" "ACE var"

      f_echo "Installation of the ACE var complete"

    else

      f_echo "RSYNC of the ACE var failed with error ${varStatus}"

      # Remove the partial image
      rm -rf ${aceVar}

      # Clean the lock to allow the next guy to try again
      f_remove_lock "${aceVar}" "ACE var"

      # Return with the bad code
      return ${varStatus}

    fi
  fi
fi


#########################################################################################

# Return with success
return 0
