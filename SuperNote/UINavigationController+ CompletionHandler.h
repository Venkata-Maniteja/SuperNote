//
//  UINavigationController+ CompletionHandler.h
//  
//
//  Created by Venkata Maniteja on 2016-01-26.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController(CompletionHandler)

- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion;


@end
