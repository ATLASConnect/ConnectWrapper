ConnectWrapper
=============

ConnectWrapper provides an Atlas Complaint Environment on a Remote Cluster


History
=======
20150128  4.5-2  Change location of OSG and ACE downloads to "/home/www/download"
20150127  4.5-1  Fixed some typos
20150126  4.5-0  Add support for _RCC_USE_TB_ACE_xxx. Move all _DF_ to setup_site.sh. Rename setup_osg to setup_wnc
20150113  4.4-0  Make HTTP_PROXY separate option from ParrotProxy
20141216  4.3-0  Add ClientCVMFS type (CVMFS Client + ACE etc)
20141210  4.2-1  Fix function search in f_echo to setup_functions
20141210  4.2-0  Change all conf files to setup_xxxx.sh (setup_defaults, setup_site, setup_functions)
20141209  4.1-0  Merge all site.conf into one
20141209  4.0-4  Some cleanup of site.conf.XXX in preparation for merger
20141206  4.0-3  Remove colon seperator from $CFLAGS and $CXXFLAGS functions
20141206  4.0-2  A few other output display fixes
20141205  4.0-1  Fix typos in output displays
20141204  4.0-0  Split out all defaults to defaults.conf 
                 Add support for $CFLAGS and $CXXFLAGS
                 Add --sysroot=$ACEImage
                 Parrot 4.2.2
20141111  3.0-12 Some cleanup of the various CVMFS types
20141111  3.0-11 Add ReplicaCVMFS (works same as nfsCVMFS)
20141030  3.0-10 Add /usr/include/libxml2/libxml to $C_INCLUDE_PATH in setup_ace.sh
20141021  3.0-9  Set $USER on OSG_APP/atlas_app/atlaswn/setup.sh
20141020  3.0-8  Change default frontier server url to remove RAL
20141009  3.0-7	 Change default frontier server url to remove BNL
20140915  3.0-6	 Change default squid form uct2-grid1.mwt2.org to uct2-squid.mwt2.org
20140817  3.0-5	 Define $CPATH, $CPLUS_INCLUDE_PATH and $DYLD_LIBRARY_PATH
20140814  3.0-4	 Dyamically add all directories in /usr/include to $C_INCLUDE_PATH
20140814  3.0-3	 Add "libxml" to $C_INCLUDE_PATH
20140804  3.0-2	 Add $C_INCLUDE_PATH and $LIBRARY_PATH definitions
20140804  3.0-1	 Put ACE path definitions at the beginning of the $PATH
20140801  3.0-0	 First release after rebranding from ParrotWrapper
