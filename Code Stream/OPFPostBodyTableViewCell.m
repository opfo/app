//
//  OPFPostBodyTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostBodyTableViewCell.h"
#import "NSString+OPFEscapeStrings.h"
#import "OPFQuestion.h"
#import "OPFQuestionViewController.h"
#import "OPFWebViewController.h"

@implementation OPFPostBodyTableViewCell
@synthesize htmlString = _htmlString;

- (void)setHtmlString:(NSString *)htmlString {
	_htmlString = htmlString;
	
	if (!self.bodyTextView.loading)
		[self reloadHTMLWithString:htmlString];
}



- (void)reloadHTMLWithString:(NSString *)content {
	NSString *command = [NSString stringWithFormat:@"loadBody(\"%@\")", [content OPF_escapeWithScheme:OPFEscapePrettify]];
	[self.bodyTextView stringByEvaluatingJavaScriptFromString:command];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// Insert html from database and run prettify
	[self reloadHTMLWithString:_htmlString];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	DLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if(navigationType==UIWebViewNavigationTypeLinkClicked) {
        DLog(@"Button clicked");
        // If the link is to a stackoverflow question
		if([[request.URL absoluteString] rangeOfString:@"stackoverflow.com/questions/"].location != NSNotFound){
           
            // Strip out the questionID
            NSUInteger n = [[request.URL absoluteString] rangeOfString:@"stackoverflow.com/questions/"].location + 28;
            NSString *questionId = [[request.URL absoluteString] substringFromIndex:n];
            questionId = [questionId substringToIndex:[questionId rangeOfString:@"/"].location];
            
            //Query question and see if it exist in the database
            OPFQuestion *question = [[OPFQuestion.query whereColumn:@"id" is:questionId] getOne];
            
            // If our question exist in our local DB
            if(question != nil){
                OPFQuestionViewController *questionView = [OPFQuestionViewController new];
                questionView.question = question;
                [self.navigationcontroller pushViewController:questionView animated:YES];
            }
            // Oterwise open the stackoverflow webpage
            else{
                OPFWebViewController *webBrowser = [OPFWebViewController new];
                webBrowser.page=request.URL;
                [self.navigationcontroller pushViewController:webBrowser animated:YES];
            }
            
            return NO;
            
        }
        else{
            OPFWebViewController *webBrowser = [OPFWebViewController new];
            webBrowser.page = request.URL;
            [self.navigationcontroller pushViewController:webBrowser animated:YES];
            return NO;
        }
        
	}
    else
        return YES;
}

- (void)awakeFromNib {
	self.bodyTextView.keyboardDisplayRequiresUserAction = NO;
	self.bodyTextView.mediaPlaybackAllowsAirPlay = NO;
	self.bodyTextView.mediaPlaybackRequiresUserAction = NO;
	self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
	self.bodyTextView.delegate = self;
	self.bodyTextView.scrollView.scrollEnabled = NO;
	self.bodyTextView.scrollView.bounces = NO;
	
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"bodytemplate" ofType:@"html"];
	NSURL *bundle = [[NSBundle mainBundle] bundleURL];

	if (htmlPath && bundle) {
        NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
        [self.bodyTextView loadData:htmlData MIMEType:@"text/html"
						textEncodingName:@"utf-8" baseURL:bundle];
    }
	
}

@end
