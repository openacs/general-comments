# /packages/general-comments/www/view-image.tcl

ad_page_contract {
    Views an attached image
    
    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    image_id:notnull
    { return_url {} }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    return_url:onevalue
    image_id:onevalue
    width:onevalue
    height:onevalue
}

# check that user can view the image
ad_require_permission $image_id read

# get the image attributes
db_1row get_image {
    select i.name,
           r.title,
           m.width,
           m.height
      from cr_items i, 
           cr_revisions r, 
           images m
     where i.item_id = :image_id and
           r.revision_id = i.live_revision and
           r.revision_id = m.image_id
}

set page_title "Image attachment"
set context_bar {[list "$return_url" "Go back to comment"] "Image attachment"}

ad_return_template

