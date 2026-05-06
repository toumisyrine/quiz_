import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';

import { DataService } from './data.service';
import { NavbarComponent } from './components/navbar/navbar.component';
import { FooterComponent } from './components/footer/footer.component';

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    HttpClientModule,
    RouterModule,
    NavbarComponent,
    FooterComponent
  ],
  providers: [
    DataService
  ],
  exports: [
    NavbarComponent,
    FooterComponent,
    CommonModule,
    HttpClientModule,
    RouterModule
  ]
})
export class CoreModule { }