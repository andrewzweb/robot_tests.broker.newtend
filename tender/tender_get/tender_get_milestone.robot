*** Variables ***

*** Keywords ***

Отримати інформацію про milestones[0].title
  Check Lot Stash Is Open
  Wait And Click  xpath=//h2[@class="tender-block__title tender-block__title--bold ng-binding ng-scope"]
  ${result}=  Get Text  ${locator.view_milestone[0].title}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[0].code
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[0].code}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[0].percentage
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[0].percentage}
  ${result}=  Get Substring  ${result}  0  -2
  ${result}=  Convert To Number  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[0].duration.days
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[0].duration_days}
  ${result}=  Convert To Integer  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[0].duration.type
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[0].duration_type}
  ${result}=  convert_to_newtend_normal  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[1].title
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[1].title}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[1].code
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[1].code}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[1].percentage
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[1].percentage}
  ${result}=  Get Substring  ${result}  0  -2
  ${result}=  Convert To Number  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[1].duration.days
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[1].duration_days}
  ${result}=  Convert To Integer  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[1].duration.type
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[1].duration_type}
  ${result}=  convert_to_newtend_normal  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[2].title
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[2].title}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[2].code
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[2].code}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[2].percentage
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[2].percentage}
  ${result}=  Get Substring  ${result}  0  -2
  ${result}=  Convert To Number  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[2].duration.days
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[2].duration_days}
  ${result}=  Convert To Integer  ${result}
  [Return]  ${result}

Отримати інформацію про milestones[2].duration.type
  Check Lot Stash Is Open
  ${result}=  Get Text  ${locator.view_milestone[2].duration_type}
  ${result}=  convert_to_newtend_normal  ${result}
  [Return]  ${result}    

