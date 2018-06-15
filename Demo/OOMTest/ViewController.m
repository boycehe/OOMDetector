//
//  ViewController.m
//  OOMTest
//
//  Created by heboyce on 2018/6/14.
//  Copyright © 2018年 shaodonggao. All rights reserved.
//

#import "ViewController.h"

#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <mach/mach.h>
#import <malloc/malloc.h>
#import <mach/vm_types.h>
#import <CommonCrypto/CommonDigest.h>
#import <mach-o/loader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
   uint32_t count = _dyld_image_count();
  for (uint32_t i = 0; i < count; i++) {
    //获取image结构头
    const struct mach_header_64* header = (const struct mach_header_64*)_dyld_get_image_header(i);
    //获取image name
    const char* name = _dyld_get_image_name(i);
    //查找一个字符串在另一个字符串中 末次 出现的位置，并返回从字符串中的这个位置起，一直到字符串结束的所有字符；
    const char* tmp = strrchr(name, '/');
    printf("--------------------\n");
    printf("1--%s\n",tmp);
    //获取image偏移地址
    long slide = _dyld_get_image_vmaddr_slide(i);
    //这里为什么要加1？？
    if (tmp) {
      name = tmp + 2;
    }
  
    printf("header:%ld\n",(long)header);
    long offset = (long)header + sizeof(struct mach_header_64);
    printf("offset:%ld\n",offset);
    
    printf("2--%s\n",name);
    printf("*******************\n");
    
    
    for (unsigned int i = 0; i < header->ncmds; i++) {
      
      const struct segment_command_64* segment = (const struct segment_command_64*)offset;
   
      
      if (segment->cmd == LC_SEGMENT_64 && strcmp(segment->segname, SEG_TEXT) == 0) {
        
        long begin = (long)segment->vmaddr + slide;
        long end = (long)(begin + segment->vmsize);
      
      
        break;
      }
      
      offset += segment->cmdsize;
    }
    
  
  }
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
