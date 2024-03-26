
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProductCategoryRoutingModule } from './product-category-routing.module';
import { ProductCategoryComponent } from './product-category.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TabsModule } from 'ngx-bootstrap/tabs';

@NgModule({
  declarations: [
    ProductCategoryComponent
  ],
  imports: [
    CommonModule,
    ProductCategoryRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    TabsModule,
    ModalModule
  ]
})
export class ProductCategoryModule { }
