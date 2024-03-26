
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AddressRoutingModule } from './address-routing.module';
import { AddressComponent } from './address.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';

@NgModule({
  declarations: [
    AddressComponent
  ],
  imports: [
    CommonModule,
    AddressRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    ModalModule.forRoot(),
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
  ]
})
export class AddressModule { }
