
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ContactFormsRoutingModule } from './contact-forms-routing.module';
import { ContactFormsComponent } from './contact-forms.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { ModalModule } from 'ngx-bootstrap/modal';
import { FormsModule } from '@angular/forms';
import { NgxSpinnerModule } from 'ngx-spinner';

@NgModule({
  declarations: [
    ContactFormsComponent
  ],
  imports: [
    CommonModule,
    ContactFormsRoutingModule,
    ModalModule.forRoot(),
    FormsModule,
    NgxSpinnerModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    NgxPaginationModule

  ]
})
export class ContactFormsModule { }
