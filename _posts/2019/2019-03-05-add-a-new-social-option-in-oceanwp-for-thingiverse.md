---
post_id: 4004
title: 'Add a new social option in OceanWP (for Thingiverse)'
date: '2019-03-05T01:15:06+01:00'
last_modified_at: '2021-06-12T21:14:51+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4004'
slug: add-a-new-social-option-in-oceanwp-for-thingiverse
permalink: /2019/03/add-a-new-social-option-in-oceanwp-for-thingiverse/
image: /files/2018/10/wordpress_1540683760.jpg
categories:
    - Informatique
tags:
    - OceanWP
    - Wordpress
lang: en
---

If you want to add a new social option in the topbar of OceanWP, you may have seen the OceanWP documentation [here](https://docs.oceanwp.org/article/365-add-new-social-options-for-the-top-bar-and-the-social-menu). But it adds it at the end. You you wish to reorder the new social option, here is a little trick, by inserting the new option in the correct place in the array instead of adding it to the end. Code below to be added to your child theme functions.php file :

```
// https://stackoverflow.com/questions/2149437/how-to-add-an-array-value-to-the-middle-of-an-associative-array
function insertBeforeKey($array, $key, $data = null)
{
    if (($offset = array_search($key, array_keys($array))) === false) // if the key doesn't exist
    {
        $offset = 0; // should we prepend $array with $data?
        $offset = count($array); // or should we append $array with $data? lets pick this one...
    }

    return array_merge(array_slice($array, 0, $offset), (array) $data, array_slice($array, $offset));
}

/**
 * Add new social options in the Customizer
 */
function my_ocean_social_options( $array ) {
	// Thingiverse icon
	$array = insertBeforeKey($array, 'dribbble', array('thingiverse' => array(
		'label' => 'Thingiverse',
		'icon_class' => 'fa fa-cube',
	)));

	// Return
	return $array;

}
add_filter( 'ocean_social_options', 'my_ocean_social_options' );
```

**Update (12/06/2021) :** With version OceanWP 2.0.9 or later, OceanWP has [introduced a change](https://docs.oceanwp.org/article/365-add-new-social-options-for-the-top-bar-and-the-social-menu) that breaks the above solution, but the indication they gave [on their article](https://docs.oceanwp.org/article/365-add-new-social-options-for-the-top-bar-and-the-social-menu) does not seem to work, at least on my version. Below is a working solution for me (still using FontAwesome) :

```
/**
 * Add new social options in the Customizer
 * https://docs.oceanwp.org/article/365-add-new-social-options-for-the-top-bar-and-the-social-menu
 */
function my_ocean_social_options( $array ) {
	// Thingiverse icon
	$array = insertBeforeKey($array, 'dribbble', array('thingiverse' => array(
		'label' => 'Thingiverse',
		'icon_class' => oceanwp_icon( 'cube', false, "fa fa-cube"), //  before 12/06/2021 : 'fa fa-cube', 
	)));
	return $array;
}
add_filter( 'ocean_social_options', 'my_ocean_social_options' );

```