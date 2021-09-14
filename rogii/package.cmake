set(
    JSON_MultipleHeaders
    ON
)

if(NOT TARGET RapidJSON)
	add_library(
		RapidJSON
		INTERFACE
		IMPORTED
	)
	set_target_properties(
		RapidJSON
		PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES
				"${CMAKE_CURRENT_LIST_DIR}/include"
	)
endif()
