#-------------------------------------------------------------------------------
# Modules Installation configuration
#-------------------------------------------------------------------------------
set(GW_MODULE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
set(GW_MODULE_BINARY_DESTINATION  ${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME}/)
set(GW_MODULE_LIBRARY_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${PROJECT_NAME}/)
set(GW_MODULE_ARCHIVE_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${PROJECT_NAME}/)

function(gw_add_module MODULE)
    install(TARGETS ${MODULE}
        COMPONENT modules
        RUNTIME DESTINATION ${GW_MODULE_BINARY_DESTINATION}
        LIBRARY DESTINATION ${GW_MODULE_LIBRARY_DESTINATION}
        ARCHIVE DESTINATION ${GW_MODULE_ARCHIVE_DESTINATION}
    )
    set_target_properties(${MODULE} PROPERTIES
        INSTALL_RPATH ${GW_MODULE_LIBRARY_DESTINATION}:\$ORIGIN:\$ORIGIN/../../lib/${PROJECT_NAME}/
        BUILD_WITH_INSTALL_RPATH ON
    )
endfunction()

function(gw_add_module_data MODULE DATAPATH)
    #no-op
endfunction()

function(gw_install_shared SUBFOLDER SHARES COMPONENT)
    install(FILES ${SHARES}
        COMPONENT ${COMPONENT}
        DESTINATION ${GW_MODULE_BINARY_DESTINATION}
    )
endfunction(gw_install_shared)

function(gw_install_module_library MODULE_LIB)
    install(TARGETS ${MODULE_LIB}
        COMPONENT modules
        DESTINATION ${GW_MODULE_BINARY_DESTINATION}
    )
    set_target_properties(${MODULE_LIB} PROPERTIES
        INSTALL_RPATH ${GW_MODULE_LIBRARY_DESTINATION}:\$ORIGIN:\$ORIGIN/../../lib/${PROJECT_NAME}/
        BUILD_WITH_INSTALL_RPATH ON
    )
endfunction()