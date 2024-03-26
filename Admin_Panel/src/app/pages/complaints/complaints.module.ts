
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ComplaintsRoutingModule } from './complaints-routing.module';
import { ComplaintsComponent } from './complaints.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { ModalModule } from 'ngx-bootstrap/modal';
import { FormsModule } from '@angular/forms';
import { NgxSpinnerModule } from 'ngx-spinner';

@NgModule({
  declarations: [
    ComplaintsComponent
  ],
  imports: [
    CommonModule,
    ComplaintsRoutingModule,
    ModalModule.forRoot(),
    FormsModule,
    NgxSpinnerModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    NgxPaginationModule
  ]
})
export class ComplaintsModule { }
