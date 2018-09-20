//
//  IonHomeProfileContentCell.m
//  IonNews
//
//  Created by Himanshu Rajput on 30/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonHomeProfileContentCell.h"
#import "Ionconstant.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation IonHomeProfileContentCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([[IonUtility sharedInstance] isLikeView] == 1) {
        return self.result.count;
    }else{
        return self.titlesForStory.count;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(self.collectionView.frame.size.width/2 - 1, self.collectionView.frame.size.width/2);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IonHomeProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeProfileCell" forIndexPath:indexPath];
    NSString *url;
    NSString* webStringURL;
    if ([[IonUtility sharedInstance] isLikeView] == 1) {
       url  = [[self.result objectAtIndex:indexPath.row] valueForKey:@"image"];
        webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.title.text = [[[self.result objectAtIndex:indexPath.row] valueForKey:@"title"] uppercaseString];
        cell.subtitle.text = [[self.result objectAtIndex:indexPath.row] valueForKey:@"sub_title"];
    }else{
        if ( self.resultForStory.count > 1) {
            url = [[[self.resultForStory valueForKey:[self.titlesForStory objectAtIndex:indexPath.row]] objectAtIndex:0] valueForKey:@"image"];
            webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cell.title.text = [[self.titlesForStory objectAtIndex:indexPath.row] uppercaseString];
            cell.subtitle.text = [[[self.resultForStory valueForKey:[self.titlesForStory objectAtIndex:indexPath.row]] objectAtIndex:0] valueForKey:@"title"];
        }
    }
    
       NSURL * URL = [NSURL URLWithString:webStringURL];
//        [[ion_imageUrlrequest shared]setImageWithUrl:URL withHandler:^(id  _Nullable image, NSError * _Nullable error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = image;
//        });
//
//        }];
    
    [cell.imageView sd_setImageWithURL:URL placeholderImage:nil];

        UIFont *fontText = [UIFont fontWithName:@"OpenSans-Bold" size:17];
        // you can use your font.
        
        CGSize maximumLabelSize = CGSizeMake(cell.frame.size.width, cell.frame.size.height/2);
        
        CGRect textRect = [cell.title.text boundingRectWithSize:maximumLabelSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:fontText}
                                                 context:nil];
        
   CGSize     expectedLabelSize = CGSizeMake(textRect.size.width, textRect.size.height);
        
        cell.heightForTitle.constant = expectedLabelSize.height;
       
        cell.backgroundColor= [UIColor colorWithRed:93.0/255.0 green:67.0/255.0 blue:147.0/255.0 alpha:1.0];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[IonUtility sharedInstance] isLikeView] == 0){
    
    NSNumber * num = [[[self.resultForStory valueForKey:[self.titlesForStory objectAtIndex:indexPath.row]] objectAtIndex:0] objectForKey:@"category_id"];
    [self.delegate presentViewController:[num intValue] title:[self.titlesForStory objectAtIndex:indexPath.row]];
    }else{
    [self.delegate presentViewController:0 title:[self.titlesForStory objectAtIndex:indexPath.row]];
    }
    

}





@end
