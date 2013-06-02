require 'x12'

#These is test sample for edi 997 functional acknowledgment
class Edi::Interchange

  def self.generate
    parser = X12::Parser.new('997.xml')

    r = parser.factory('997')

    r.ST.TransactionSetIdentifierCode = 997
    r.ST.TransactionSetControlNumber  = '2878'

    r.AK1 { |ak1|
      ak1.FunctionalIdentifierCode = 'HS'
      ak1.GroupControlNumber       = 293328532
    }

    r.L1000.L1010.AK4.DataElementSyntaxErrorCode = 55
    r.L1000.AK2.TransactionSetIdentifierCode     = 270

    r.L1000.L1010 {|l|
      l.AK3 {|s|
        s.SegmentIdCode      = 'NM1'
        s.LoopIdentifierCode = 'L1000D'
      }
      l.AK4 {|s|
        s.CopyOfBadDataElement = 'Bad element'
      }
    }

    r.L1000.repeat {|l1000|
      (0..1).each {|loop_repeat| # Two repeats of the loop L1010
        l1000.L1010.repeat {|l1010|
          l1010.AK3 {|s|
            s.SegmentIdCode                   = 'DMG'
            s.SegmentPositionInTransactionSet = 0
            s.LoopIdentifierCode              = 'L1010'
            s.SegmentSyntaxErrorCode          = 22
          } if loop_repeat == 0 # AK3 only in the first repeat of L1010
          (0..1).each {|ak4_repeat| # Two repeats of the segment AK4
            l1010.AK4.repeat {|s|
              s.PositionInSegment          = loop_repeat
              s.DataElementSyntaxErrorCode = ak4_repeat
            } # s
          } # ak4_repeat
        } # l1010
      } # loop_repeat


      l1000.AK5{|a|
        a.TransactionSetAcknowledgmentCode = 666
        a.TransactionSetSyntaxErrorCode4   = 999
      } # a
    } # l1000

    r.render
  end

  def self.parsing
    parser = X12::Parser.new('997.xml')

    # Define a test message to parse
    m997='ST*997*2878~AK1*HS*293328532~AK2*270*307272179~'\
    'AK3*NM1*8*L1010_0*8~AK4*0:0*66*1~AK4*0:1*66*1~AK4*0:2*'\
    '66*1~AK3*NM1*8*L1010_1*8~AK4*1:0*66*1~AK4*1:1*66*1~AK3*'\
    'NM1*8*L1010_2*8~AK4*2:0*66*1~AK5*R*5~AK9*R*1*1*0~SE*8*2878~'

    # Parse the message
    r = parser.parse('997', m997)
    r.show

    # Access components of the message as desired

    # Whole ST segment: -> ST*997*2878~
    puts r.ST

    # One filed, Group Control Number of AK1 -> 293328532
    puts r.AK1.GroupControlNumber

    # Individual loop, namely, third L1010 subloop of
    # L1000 loop: -> AK3*NM1*8*L1010_2*8~AK4*2:0*66*1~
    puts r.L1000.L1010[2]

    # First encounter of Data Element Reference Number of the
    # first L1010 sub-loop of L1000 loop -> 66
    puts r.L1000.L1010.AK4.DataElementReferenceNumber

    # Number of L1010 sub-loops in L1000 loop -> 3
    puts r.L1000.L1010.size
  end
end
