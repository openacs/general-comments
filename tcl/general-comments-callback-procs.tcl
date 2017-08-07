ad_library {
    Callback Procs for general comments

}

namespace eval general_comments {}


ad_proc -public -callback general_comments::notify_objects {
    {-object_id:required}
    {-comment:required}
    {-title:required}
    {-object_type:required}
} {
    This callback is being called once a comment has been added

    @param object_id Object ID of the object to which the comment was added
    @param title Title given with the comment
    @param comment Comment that was provided. This is HTML.
    @param object_type Object Type of the object id. This is useful to quickly say in the package implementations whether you want to deal with the comment or not.
} -

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
