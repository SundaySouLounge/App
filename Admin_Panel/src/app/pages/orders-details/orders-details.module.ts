
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { OrdersDetailsRoutingModule } from './orders-details-routing.module';
import { OrdersDetailsComponent } from './orders-details.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TabsModule } from 'ngx-bootstrap/tabs';

@NgModule({
  declarations: [
    OrdersDetailsComponent
  ],
  imports: [
    CommonModule,
    OrdersDetailsRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    TabsModule,
    ModalModule
  ]
})
export class OrdersDetailsModule { }
