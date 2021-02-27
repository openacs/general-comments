ad_library {
    Test general-comments API
}

aa_register_case \
    -cats {api smoke} \
    -procs {
        general_comments_create_link
        general_comments_package_url

        ad_convert_to_html
    } \
    general_comments_create_link {
        Test general_comments_create_link and
        general_comments_package_url
    } {
        set gc_url [general_comments_package_url]

        set vars {
            object_name
            link_text
            context_id
            category
            link_attributes
            object_id
            return_url
        }
        foreach var $vars {
            set $var [ad_generate_random_string]
        }

        set url [general_comments_create_link \
                     -object_name $object_name \
                     -link_text $link_text \
                     -context_id $context_id \
                     -category $category \
                     -link_attributes $link_attributes \
                     $object_id $return_url]

        aa_true "Generated link is HTML" [ad_looks_like_html_p $url]

        foreach var $vars {
            aa_true "Link contains supplied argument '$var'" {[string first [set $var] $url] >= 0}
        }

        if {$gc_url ne ""} {
            aa_true "Link contains general-comments package URL '$gc_url'" {[string first $gc_url $url] >= 0}
        }
    }

aa_register_case \
    -cats {api smoke} \
    -procs {
        general_comments_new
        general_comments_get_comments
    } \
    general_comments_create_retrieve {
        Test general_comments_new and general_comments_get_comments
    } {
        aa_run_with_teardown -rollback -test_code {
            set object_id [db_string get_object {
                select object_id from acs_objects
                where object_type <> 'apm_package'
                fetch first 1 rows only
            }]

            set context_id [db_string get_package {
                select package_id from apm_packages fetch first 1 rows only
            }]

            set other_context_id [db_string get_package {
                select package_id from apm_packages
                where package_id <> :context_id
                fetch first 1 rows only
            }]

            set comments_info [list]
            for {set i 0} {$i < 5} {incr i} {
                set comment_id [db_nextval acs_object_id_seq]
                set title [ad_generate_random_string]
                set category [ad_generate_random_string]
                set content [ad_generate_random_string]
                general_comments_new \
                    -object_id $object_id \
                    -comment_id $comment_id \
                    -title $title \
                    -comment_mime_type "text/plain" \
                    -context_id $context_id \
                    -category $category \
                    -content $content \
                    -is_live true
                lappend comments_info [list \
                                           comment_id $comment_id \
                                           title $title \
                                           category $category \
                                           content $content]
            }

            aa_section "Check that comment has been stored as expected (e.g. category)"
            foreach c $comments_info {
                set comment_id [dict get $c comment_id]
                set category [dict get $c category]
                aa_true "Comment '$comment_id' was stored correctly" [db_0or1row check_comment {
                    select 1
                    from general_comments c, acs_objects o
                    where c.comment_id = o.object_id
                    and c.category = :category
                    and c.object_id = :object_id
                    and o.context_id = :context_id
                    and c.comment_id = :comment_id
                }]
            }

            aa_section "Rendering comments for '$object_id': no content, no context constraint"
            set comments [general_comments_get_comments $object_id]
            aa_true "Generated rendering is HTML" [ad_looks_like_html_p $comments]
            foreach c $comments_info {
                set comment_id [dict get $c comment_id]
                aa_true "Comment Id '$comment_id' is in markup" {[string first $comment_id $comments] >= 0}

                set title [dict get $c title]
                aa_true "Title '$title' is in markup" {[string first $title $comments] >= 0}

                set content [dict get $c content]
                aa_false "Content '$content' is not in markup" {[string first $content $comments] >= 0}
            }

            aa_section "Rendering comments for '$object_id': with content, filtering for another context_id"
            set comments [general_comments_get_comments -print_content_p 1 $object_id]
            aa_true "Generated rendering is HTML" [ad_looks_like_html_p $comments]
            foreach c $comments_info {
                set comment_id [dict get $c comment_id]
                aa_true "Comment Id '$comment_id' is in markup" {[string first $comment_id $comments] >= 0}

                set title [dict get $c title]
                aa_true "Title '$title' is in markup" {[string first $title $comments] >= 0}

                set content [dict get $c content]
                aa_true "Content '$content' is in markup" {[string first $content $comments] >= 0}
            }

            aa_section "Rendering comments for '$object_id': with content and context constraint"
            set comments [general_comments_get_comments \
                              -print_content_p 1 \
                              -context_id $other_context_id \
                              $object_id]
            foreach c $comments_info {
                set comment_id [dict get $c comment_id]
                aa_false "Comment Id '$comment_id' is not in markup" {[string first $comment_id $comments] >= 0}

                set title [dict get $c title]
                aa_false "Title '$title' is not in markup" {[string first $title $comments] >= 0}

                set content [dict get $c content]
                aa_false "Content '$content' is not in markup" {[string first $content $comments] >= 0}
            }
        }
    }
