# == Schema Information
# Schema version: 20101214111833
#
# Table name: hobbies
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Hobby < ActiveRecord::Base
  FROM_EXCEL = {
    'Archivo'   => 'Archivo, Hemeroteca y Publicaciones',
    'Artes'     => 'Artes plásticas',
    'Casino'    => 'Casino de la exposición',
    'Centro'    => 'Centro de las Artes de Sevilla',
    'Cine'      => 'Cine',
    'ConsejoCE' => 'Consejo cultura y empresa',
    'ConsejoP'  => 'Consejo de publicaciones',
    'Danza'     => 'Danza',
    'Foro'      => 'Foro de agentes culturales',
    'Libros'    => 'Libros - poesía',
    'Música'    => 'Música',
    'Red'       => 'Red Municipal de Bibliotecas',
    'Teatro'    => 'Teatro',
    'TeatroA'   => 'Teatro Alameda',
    'TeatroLV'  => 'Teatro Lope de Vega'
  }
  
  validates_presence_of :name
end
