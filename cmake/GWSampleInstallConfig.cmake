#-------------------------------------------------------------------------------
# Samples Installation configuration
#-------------------------------------------------------------------------------
set(GW_SAMPLE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/example/${PROJECT_NAME}/")
set(GW_SAMPLE_BINARY_DESTINATION  ${GW_SAMPLE_INSTALL_PREFIX}/bin)
set(GW_SAMPLE_LIBRARY_DESTINATION ${GW_SAMPLE_INSTALL_PREFIX}/lib)
set(GW_SAMPLE_ARCHIVE_DESTINATION ${GW_SAMPLE_INSTALL_PREFIX}/lib)

function(gw_add_sample SAMPLE)
    install(TARGETS ${SAMPLE}
        COMPONENT samples
        RUNTIME DESTINATION ${GW_SAMPLE_BINARY_DESTINATION}
        LIBRARY DESTINATION ${GW_SAMPLE_LIBRARY_DESTINATION}
        ARCHIVE DESTINATION ${GW_SAMPLE_ARCHIVE_DESTINATION}
    )
endfunction()

function(gw_add_sample_data SAMPLE DATAPATH)
    #no-op
endfunction()

function(gw_install_shared SUBFOLDER SHARES COMPONENT)
    install(FILES ${SHARES}
        COMPONENT ${COMPONENT}
        DESTINATION ${GW_SAMPLE_BINARY_DESTINATION}
    )
endfunction(gw_install_shared)

function(gw_install_sample_library SAMPLE_LIB)
    install(TARGETS ${SAMPLE_LIB}
        COMPONENT samples
        DESTINATION ${GW_SAMPLE_BINARY_DESTINATION}
    )
endfunction()