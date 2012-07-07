//
//  SearchCellDelegate.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//


@protocol SearchCellDelegate
-(void)searchCellSearchFor:(NSString *)string Kind:(NSInteger)kind;
-(void)searchCellDidSelectGenre;
@end
