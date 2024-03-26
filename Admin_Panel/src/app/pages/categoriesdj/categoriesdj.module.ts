

import { CommonModule } from '@angular/common';

import { CategoriesdjRoutingModule } from './categoriesdj-routing.module';
import { CategoriesdjComponent } from './categoriesdj.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TabsModule } from 'ngx-bootstrap/tabs';
import { NgModule } from '@angular/core';

@NgModule({
  declarations: [
    CategoriesdjComponent
  ],
  imports: [
    CommonModule,
    CategoriesdjRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    TabsModule,
    ModalModule
  ]
})
export class CategoriesdjModule { }
